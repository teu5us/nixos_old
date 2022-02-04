{-# LANGUAGE StandaloneDeriving #-}
-- Put the following in your vimrc to have folds enabled by default:
-- `au BufEnter *.hs set foldmethod=marker | set foldmarker={{{,}}}` | norm zM

-- Imports {{{
-- Main Imports {{{
import           XMonad
import           XMonad.Config.Desktop
import           XMonad.Hooks.DynamicLog        ( PP(..)
                                                , defaultPP
                                                , dynamicLogWithPP
                                                , pad
                                                , shorten
                                                , wrap
                                                , xmobarColor
                                                , xmobarPP
                                                )
import           XMonad.Layout
import           XMonad.ManageHook
import           XMonad.Operations
import qualified XMonad.StackSet               as W
-- }}}

-- Additional Imports {{{
import           Control.Monad
import           Data.List
import qualified Data.Map                      as M
import           Data.Maybe                     ( isJust )
import           Data.Monoid
import           Graphics.X11.ExtraTypes.XF86
import           System.Exit
-- }}}

-- Actions {{{
import           XMonad.Actions.CopyWindow
import           XMonad.Actions.CycleWS
import qualified XMonad.Actions.FlexibleResize as Flex
import           XMonad.Actions.Minimize
import           XMonad.Actions.WindowBringer
import           XMonad.Actions.WithAll
import           XMonad.Actions.FloatSnap
import           XMonad.Actions.GridSelect
import           XMonad.Actions.MouseGestures
-- }}}

-- Hooks {{{
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.ManageHelpers
import           XMonad.Hooks.PerWindowKbdLayout
import           XMonad.Hooks.Place
import           XMonad.Hooks.SetWMName
-- }}}

-- Prompt {{{
import           XMonad.Prompt
import           XMonad.Prompt.AppLauncher     as AL
import           XMonad.Prompt.Shell
-- }}}

-- Util {{{
import           XMonad.Util.EZConfig
import           XMonad.Util.NamedScratchpad
import           XMonad.Util.NoTaskbar
import           XMonad.Util.Paste              ( sendKey
                                                , noModMask
                                                )
import           XMonad.Util.Run                ( hPutStrLn
                                                , spawnPipe
                                                )
-- }}}

-- Layouts {{{
import           XMonad.Layout.ResizableTile
import           XMonad.Layout.Tabbed
import           XMonad.Layout.TwoPane
import           XMonad.Layout.ZoomRow
-- }}}

-- Layout modifiers {{{
import           XMonad.Layout.BoringWindows
import           XMonad.Layout.ComboP
import           XMonad.Layout.Gaps
import           XMonad.Layout.Minimize
import           XMonad.Layout.MultiToggle
import           XMonad.Layout.MultiToggle.Instances
import           XMonad.Layout.NoBorders
import qualified XMonad.Layout.Renamed         as R
import           XMonad.Layout.Spacing
import           XMonad.Layout.TabBarDecoration
import qualified XMonad.Layout.ToggleLayouts   as TL
import           XMonad.Layout.WindowArranger
import qualified XMonad.Layout.WindowNavigation
                                               as WN
-- }}}
-- }}}

-- Definitions {{{
-- Terminal command to use
myTerm = "alacritty"
-- Window Count
windowCount =
    gets
        $ Just
        . show
        . length
        . W.integrate'
        . W.stack
        . W.workspace
        . W.current
        . windowset

-- Get the name of the active layout.
getActiveLayoutDescription :: X String
getActiveLayoutDescription = do
    workspaces <- gets windowset
    return $ description . W.layout . W.workspace . W.current $ workspaces
-- }}}

withFloating :: X () -> X () -> X ()
withFloating f1 f2 = withFocused $ \windowID -> do
    floats <- gets $ W.floating . windowset
    if windowID `M.member` floats then f1 else f2

sendKeySequence :: [(KeyMask, KeySym)] -> X ()
sendKeySequence lst = sequence_ $ do
    (m, s) <- lst
    return $ sendKey m s

getWindowClass :: Window -> X String
getWindowClass =
    \w -> withDisplay $ \d -> fmap resClass $ io $ getClassHint d w

ifWindowClass :: String -> X () -> X () -> X ()
ifWindowClass str f1 f2 = withFocused $ \window -> do
    wclass <- getWindowClass window
    if wclass == str then f1 else f2

-- The config itself {{{
main :: IO ()
main = do
    xmproc <- spawnPipe "xmobar ~/.xmobarrc"
    xmonad
        $                         docks
        $                         ewmh desktopConfig
                                      { manageHook         = myManageHook
                                      , terminal           = myTerm
                                      , modMask            = mod4Mask
                                      , keys               = myRedefinedKeys
                                      , focusedBorderColor = "#D8DEE9"
                                      , normalBorderColor  = "#2E3440"
                                      , borderWidth        = 1
                                      , layoutHook         = myLayout
                                      , handleEventHook    = perWindowKbdLayout
                                      , logHook            =
                                          dynamicLogWithPP
                                          . namedScratchpadFilterOutWorkspacePP
                                          $ xmobarPP
                                                { ppOutput = hPutStrLn xmproc
                                                , ppCurrent = xmobarColor "#D8DEE9" ""
                                                                  . wrap "[ <fc=#81A1C1>" "</fc> ]"
                                                , ppTitle =
                                                    xmobarColor "#D8DEE9" ""
                                                    . wrap "<fc=#EBCB8B>" "</fc>"
                                                    . shorten 60
                                                , ppSep = "<fc=#A3BE8C> :: </fc>"
                                                , ppExtras = [windowCount]
                                                , ppLayout = xmobarColor "#D8DEE9" ""
                                                                 . wrap "[ <fc=#A3BE8C>" "</fc> ]"
                                                , ppOrder = \(ws : l : t : ex) -> [ws, l] ++ ex ++ [t]
                                                }
                                      , startupHook        = myStartupHook
                                      }
        `additionalKeysP`         myAdditionalKeys
        `additionalMouseBindings` myMouseBinds
-- }}}

-- Startup {{{
myStartupHook = setWMName "LG3D"
-- }}}

-- Layouts {{{
myLayout =
    smartBorders
        $   windowArrange
        $   R.renamed [R.CutWordsLeft 1]
        $   boringWindows
        $   minimize
        $   avoidStrutsOn [U]
        $   mkToggle (NBFULL ?? EOT)
        $   mkToggle (single MIRROR)
        $   TL.toggleLayouts tabext tiled
        ||| tab
  where
    tiled =
        R.renamed [R.Replace "Tall"]
        -- $ spacingRaw True (Border 5 5 5 5) True (Border 5 5 5 5) True
                                     $ ResizableTall 1 (3 / 100) (1 / 2) []

    tab = R.renamed [R.Replace "Tab"] $ tabbed shrinkText myTabTheme

    tabext =
        R.renamed [R.Replace "TabExt"] $ smartBorders $ WN.windowNavigation
            (combineTwoP
                (TwoPane 0.03 0.75)
                (noBorders tab)
                (tabBar shrinkText myTabTheme Top $ gaps [(U, 20)] $ Mirror
                    zoomRow
                )
                myProp
            )

-- Define windows to put in main pane in TabExt {{{
myProp :: Property
myProp = Or (Or elseProp editorProp) (Or officeProp mediaProp)

mediaProp = Or (ClassName "Sxiv") (ClassName "mpv")
officeProp = Or (ClassName "Wine") (Resource "libreoffice")
elseProp = Or (ClassName "Zathura") (ClassName "Firefox")
editorProp = Or (ClassName "NVim") (ClassName "Emacs")
-- }}}

-- Theme for tabbed layout {{{
myTabTheme = def { fontName            = "xft:mono:size=10:antialias=true"
                 , decoHeight          = 20
                 , activeColor         = "#2E3440"
                 , inactiveColor       = "#2E3440"
                 , activeBorderColor   = "#D8DEE9"
                 , inactiveBorderColor = "#2E3440"
                 , activeTextColor     = "#D8DEE8"
                 }
-- }}}
-- }}}

-- ManageHook {{{
myManageHook =
    windowsManageHook <+> scratchHook <+> placeHook myPlacement <+> def

-- Place floating windows in center
-- centered = withGaps (10, 0, 10, 0) $ smart (0.5, 1.0)
myPlacement = withGaps (10, 0, 10, 0) $ underMouse (0, 0)

-- Window hooks {{{
windowsManageHook = composeOne
    [ (className =? "FireFox" <&&> resource =? "Dialog") -?> doFloat
    , className =? "Xfe" -?> doFloat
    , resource =? "maim" -?> doIgnore
    , resource =? "stalonetray" -?> doIgnore
    -- , title =? "Media viewer" -?> doIgnore
    , className =? "trayer" -?> doIgnore
    , className =? "Slop" -?> doIgnore
    , return True -?> doF W.swapDown
    , isDialog -?> doF W.shiftMaster <+> doF W.swapDown
    ]
-- }}}

-- Scratchpad hook {{{
scratchHook :: ManageHook
scratchHook = namedScratchpadManageHook scratchpads

scratchpads =
    [ NS "scratch"    spawnTerm (findTermTitle "*EQUAKE*[eDP-1]") manageTerm
    -- Run tmux scratch session in default floating window
    , NS "st-scratch" spawnST   (findTermTitle "scratch")         manageTerm
    ]
  where
  -- spawnST = "st -g 100x20 -c scratch -e tmuxdd"
    spawnST       = "alacritty -d 100 20 -t scratch -e tmuxdd"
    spawnTerm     = "emacsclient -n -e '(equake-invoke)'"
    findTermTitle = (title =?)
    findTermClass = (className =?)
    manageTerm =
        customFloating $ W.RationalRect (1 / 6) (1 / 6) (2 / 3) (2 / 3)
-- }}}
-- }}}

-- Additional Keybindings {{{
myAdditionalKeys :: [([Char], X ())]
myAdditionalKeys =
    [
        -- Launchers {{{
      ("M-' '"  , spawn myTerm)
    , ("M-' M-'", goToSelected def)
    , ("M-s", spawn "emacsclient -n -e '(equake-invoke)'")
    , ("M-' t"  , spawn "$HOME/gits/toolbox/toolbox.sh")
    , ("M-y"    , spawn "$HOME/vimclip/vimclip -y")
    , ("M-p"    , spawn "$HOME/vimclip/vimclip -p")
    , ("M-<F2>" , spawn "trayer-switch")
    , ("M-' x", spawn "xkb-switch -s 'us(dvorak)'; xtrlock-pam")
    , ("M-' w f", spawn "firefox")
    , ("M-' w c", spawn "chromium")
    , ("M-' w b", spawn "brave")
    , ("M-' S-w", spawn $ myTerm ++ " -e sudo nmtui")
    , ("M-' r"  , spawn $ myTerm ++ " -e ranger")
    , ("M-' e"  , spawn "ecl")
    , ("M-' m t", spawn "telegram-desktop")
    , ("M-' m i", spawn "ICQ")
    , ("M-' m d", spawn "Discord")
    , ("M-' m v", spawn "$HOME/vk")
    , ("M-' m s", spawn "skypeforlinux")
    , ("M-c"    , spawn "clipmenu")
    , ( "M-' i"
      , spawn $ myTerm ++ " -e htop"
      )
    -- , ( "M-a"
    --   , spawn "xkb-switch -n"
    --   )
    , ( "M-a"
      , ifWindowClass "Emacs-27.0.91"
                      (sendKey controlMask xK_backslash)
                      (spawn "xkb-switch -n")
      )
    , ( "M-' a"
      , spawn $ myTerm ++ " -e pulsemixer"
      )
    -- Hyper bindings
    , ("M3-h", sendKey noModMask xK_BackSpace)
    , ("M3-d", sendKey controlMask xK_BackSpace)
    , ("M3-u", sendKey noModMask xK_Tab)
    , ("M3-i", sendKey shiftMask xK_Tab)
    , ("M3-x", sendKey noModMask xK_Escape)
    , ("M3-m", sendKey noModMask xK_Return)
    , ("M3-b", sendKey noModMask xK_asciitilde)
    , ("M3-t", sendKey shiftMask xK_asciitilde)
    , ("M3-y", sendKey shiftMask xK_apostrophe)
    , ("M3-p", sendKey noModMask xK_apostrophe)
    , ( "M3-c"
      , sendKey mod1Mask xK_c
      )
        -- }}}
        -- Prompts {{{
    , ("M-' c s", shellPrompt def)
    , ( "M-' c a"
      , AL.launchApp def "ecl"
      )
        -- }}}
        -- Dmenu scripts {{{
    , ("M-' p", spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")
    , ("M-' C-a"   , spawn "dmenuopener")
    , ("M-`"       , spawn "dmenuunicode")
    , ("<Print>"   , spawn "screenshot")
    , ("S-<Print>" , spawn "maimpick")
    , ("M-<Print>" , spawn "dmenurecord")
    , ("M-<Delete>", spawn "killrecording")
    , ("M-<F3>"    , spawn "displayselect")
    , ("M-<F4>", spawn "prompt 'Suspend?' 'systemctl suspend'")
    , ("M-<F5>"    , spawn "sudo systemctl NetworkManager")
    , ("M-<F6>"    , spawn "st -e torwrap")
    , ("M-<F7>"    , spawn "td-toggle")
    , ("M-<F8>"    , spawn "")
    , ("M-<F9>"    , spawn "dmenumount")
    , ("M-<F10>"   , spawn "dmenuumount")
    , ("M-<F11>"   , spawn "ducksearch")
    , ( "M-<F12>"
      , spawn "prompt 'Hibernate?' 'systemctl hibernate'"
      )
        -- }}}
        -- Controls {{{
        -- , ("M-=" , spawn "lmc up 5")
        -- , ("M--" , spawn "lmc down 5")
    , ("<XF86AudioRaiseVolume>"  , spawn "lmc up 5")
    , ("<XF86AudioLowerVolume>"  , spawn "lmc down 5")
    , ("S-<XF86AudioRaiseVolume>", spawn "lmc up 10")
    , ("S-<XF86AudioLowerVolume>", spawn "lmc down 10")
    , ("M-="                     , spawn "lmc up 5")
    , ("M--"                     , spawn "lmc down 5")
    , ("M-S-="                   , spawn "lmc up 10")
    , ("M-S--"                   , spawn "lmc down 10")
    , ("<XF86AudioMute>"         , spawn "lmc mute")
    , ( "M-s m"
      , spawn "lmc mute"
      )
        -- , ("<XF86MonBrightnessUp>",   spawn "xbacklight -inc 10")
        -- , ("<XF86MonBrightnessDown>", spawn "xbacklight -dec 10")
    , ("M-S-x", spawn "prompt 'Shutdown?' 'poweroff'")
    , ( "M-C-x"
      , spawn "prompt 'Reboot?' 'reboot'"
      )
        -- }}}
        -- Window management {{{
    -- , ("M-="       , sendMessage zoomIn)
    -- , ("M--"       , sendMessage zoomOut)
    -- , ("M-<Return>", sendMessage ZoomFullToggle)
    , ( "M-x"
      , twoLayouts
          (("TabExt", sendMessage SwapWindow), ("Tall", windows W.swapMaster))
      )
    , ( "M-h"
      , withFloating (withFocused $ snapMove L Nothing)
                     (sendMessage $ WN.Go WN.L)
      )
    , ( "M-l"
      , withFloating (withFocused $ snapMove R Nothing)
                     (sendMessage $ WN.Go WN.R)
      )
    , ("M-C-<Return>", windows W.swapMaster)
    , ( "M-<Space>"
      , sendMessage NextLayout
      )
        -- , ("M-S-<Space>" , setLayout $ XMonad.layoutHook conf)
    , ("M-b"  , sendMessage ToggleStruts)
    , ("M-C-,", sendMessage (IncMasterN 1))
    , ("M-C-.", sendMessage (IncMasterN (-1)))
    , ( "M-C-h"
      , withFloating (withFocused $ snapGrow L Nothing) $ sendMessage Shrink
      )
    , ( "M-C-l"
      , withFloating (withFocused $ snapGrow R Nothing) $ sendMessage Expand
      )
    , ( "M-j"
      , withFloating (withFocused $ snapMove D Nothing) $ do
          layout <- getActiveLayoutDescription
          case layout of
              "Tall"   -> focusDown
              "Tab"    -> focusDown
              "TabExt" -> sendMessage $ WN.Go WN.D
      )
    , ( "M-k"
      , withFloating (withFocused $ snapMove U Nothing) $ do
          layout <- getActiveLayoutDescription
          case layout of
              "Tall"   -> focusUp
              "Tab"    -> focusUp
              "TabExt" -> sendMessage $ WN.Go WN.U
      )
    , ("M-."          , focusDown)
    , ("M-,"          , focusUp)
    , ("M-<Backspace>", focusMaster)
    , ( "M-S-h"
      , withFloating (withFocused $ snapShrink R Nothing)
          $ sendMessage MirrorShrink
      )
    , ( "M-S-l"
      , withFloating (withFocused $ snapShrink L Nothing)
          $ sendMessage MirrorExpand
      )
    , ( "M-C-j"
      , withFloating (withFocused $ snapGrow D Nothing) $ windows W.swapDown
      )
    , ( "M-C-k"
      , withFloating (withFocused $ snapGrow U Nothing) $ windows W.swapUp
      )
    , ("M-S-j", withFocused $ snapShrink U Nothing)
    , ("M-S-k", withFocused $ snapShrink D Nothing)
    , ("M-r", withFocused $ snapMagicResize [L, R, U, D] Nothing Nothing)
    , ("M-m", withFocused $ snapMagicMove Nothing Nothing)
    , ("M-n"  , withFocused minimizeWindow)
    , ("M-C-n", withFirstMinimized maximizeWindowAndFocus)
    , ("M-S-n", withLastMinimized maximizeWindowAndFocus)
    , ("M-q"  , kill1)
    , ("M-S-q", windows copyToAll)
    , ("M-C-q", killAllOtherCopies)
    , ("M-S-r", refresh)
    , ("M-o"  , moveTo Prev nonEmptyNonNSP)
    , ("M-e"  , moveTo Next nonEmptyNonNSP)
    , ("M-C-o", moveTo Prev nonNSP)
    , ("M-C-e", moveTo Next nonNSP)
    , ("M-u"  , shiftToPrev >> prevWS)
    , ("M-i"  , shiftToNext >> nextWS)
    , ("M-C-u", shiftTo Prev nonEmptyNonNSP >> moveTo Prev nonEmptyNonNSP)
    , ("M-C-i", shiftTo Next nonEmptyNonNSP >> moveTo Next nonEmptyNonNSP)
    , ("M-f", sendMessage (Toggle NBFULL) >> sendMessage (ToggleStrut U))
    , ("M-C-b", sendMessage TL.ToggleLayout)
    , ("M-C-f", withFocused float)
    , ("M-t"  , withFocused $ windows . W.sink)
    , ("M-C-t", sinkAll)
    , ("M-C-m", sendMessage $ Toggle MIRROR)
    , ("M-z", namedScratchpadAction scratchpads "st-scratch")
    , ("M-w g", gotoMenu)
    , ( "M-w b"
      , bringMenu
      )
        -- }}}
        -- Restart
    , ( "M-<F1>"
      , spawn "xmonad --recompile; xmonad --restart"
      )
        -- Exit
    , ("M-<Esc>", io exitSuccess)
    ]  where
    nonNSP = WSIs (return (\ws -> W.tag ws /= "NSP"))
    nonEmptyNonNSP =
        WSIs (return (\ws -> isJust (W.stack ws) && W.tag ws /= "NSP"))
-- }}}

-- Map key per layout {{{
  {--
        , ("keys" , do
          layout <- getActiveLayoutDescription
          case layout of
            "layoutname" -> ...
          )
  --}
ifLayout :: (String, X ()) -> X ()
ifLayout a = do
    layout <- getActiveLayoutDescription
    when (fst a == layout) (snd a)

twoLayouts :: ((String, X ()), (String, X ())) -> X ()
twoLayouts a = do
    ifLayout (fst a)
    ifLayout (snd a)
-- }}}

-- Mouse bindings {{{
myMouseBinds :: [((KeyMask, Button), Window -> X ())]
myMouseBinds =
    [ ( (mod4Mask, button3)
      , \w -> focus w >> Flex.mouseResizeWindow w >> afterDrag
          (snapMagicResize [L, R, U, D] (Just 100) (Just 100) w)
      )
    , ( (mod4Mask, button1)
      , (\w -> focus w >> mouseMoveWindow w >> afterDrag
            (snapMagicMove (Just 100) (Just 100) w)
        )
      )
    , ((mod4Mask, button2), \w -> focus w >> mouseGesture gestures w)
    ]

gestures = M.fromList [([], \w -> focus w >> goToSelected def)]
-- }}}

-- XMonad keys, leave only keys for monitors and workspaces {{{
myRedefinedKeys :: XConfig l -> M.Map (KeyMask, KeySym) (X ())
myRedefinedKeys conf@XConfig { XMonad.modMask = modm } =
    M.fromList
        $
    --
    -- mod-{w,e,r}, Switch to physical/Xinerama screens 1, 2, or 3
    -- mod-control-{w,e,r}, Move client to screen 1, 2, or 3
    --
                [ ( (m .|. modm, key)
                  , screenWorkspace sc >>= flip whenJust (windows . f)
                  )
           | (key, sc) <- zip [xK_bracketleft, xK_bracketright, xK_backslash]
                              [0 ..]
           , (f  , m ) <- [(W.view, 0), (W.shift, controlMask)]
           ]
        ++
-- mod-[1..9] @@ Switch to workspace N
-- mod-control-[1..9] @@ Move client to workspace N
-- mod-shift-[1..9] @@ Copy client to workspace N
           [ ((m .|. modm, k), windows $ f i)
           | (i, k) <- zip (XMonad.workspaces conf) [xK_1 .. xK_9]
           , (f, m) <- [(W.view, 0), (W.shift, controlMask), (copy, shiftMask)]
           ]
        ++ [ ((m .|. modm, k), windows $ f i)
           | (i, k) <- zip
               (XMonad.workspaces conf)
               [ xK_KP_End
               , xK_KP_Down
               , xK_KP_Page_Down
               , xK_KP_Left
               , xK_KP_Begin
               , xK_KP_Right
               , xK_KP_Home
               , xK_KP_Up
               , xK_KP_Page_Up
               ]
           , (f, m) <- [(W.view, 0), (W.shift, controlMask), (copy, shiftMask)]
           ]
-- }}}
