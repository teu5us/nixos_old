{ pkgs, lib, config, inputs, ... }:
let
  aliases = {
    # e = "emacsclient -a ''";
  };
  exwm = pkgs.writeShellScriptBin "exwm" ''
    systemctl --user stop emacs.service
    systemctl --user stop emacs.socket
    emacs --eval '(run-exwm)' && systemctl --user start emacs.socket
  '';
  e = pkgs.writeShellScriptBin "e" ''
    case "$1" in
      -t) run="" ;;
      *) run="setsid --fork" ;;
    esac
    $run emacsclient -a "" $@ 2>/dev/null
  '';
  nvim = pkgs.callPackage ./nvim.nix {};
in
rec {
  imports = [ ../../../modules/modules/shadowsocks.nix ];
  nixpkgs.config.allowUnfree = true;

  programs = {
    emacs = {
      enable = true;
      package = pkgs.emacsNativeComp;
      extraPackages = (epkgs:
        let requiredPackages =
              map (p: epkgs.${p})
                (builtins.filter
                  (p: builtins.hasAttr p epkgs && lib.isDerivation epkgs.${p})
                  (import ./files/packages.nix));
        in epkgs.withStraightOverrides requiredPackages
      );
    };

    git = {
      enable = true;
      userName = "Pavel Stepanov";
      userEmail = "paulkreuzmann@gmail.com";
      extraConfig = {
        core.compression = 9;
        http.followRedirects = "true";
        http.maxRequests = 5;
        protocol.version = 2;
        init.defaultBranch = "main";
      };
    };

    alacritty = {
      enable = true;
      settings = {
        window = {
          dimensions = {
            lines = 40;
            cols = 80;
          };
          padding = {
            x = 1;
            y = 1;
          };
          dynamic_padding = true;
          decorations = "full";
          dynamic_title = true;
        };
        scrolling = {
          history = 10000;
          multiplier = 5;
        };
        font = { size = 12; };
        opacity = 0.9;
        key_bindings = [
          {
            key = "J";
            mods = "Alt";
            action = "ScrollLineDown";
          }
          {
            key = "K";
            mods = "Alt";
            action = "ScrollLineUp";
          }
          {
            key = "Y";
            mods = "Alt";
            action = "Copy";
          }
          {
            key = "P";
            mods = "Alt";
            action = "Paste";
          }
          {
            key = "Equals";
            mods = "Alt";
            action = "IncreaseFontSize";
          }
          {
            key = "Minus";
            mods = "Alt";
            action = "DecreaseFontSize";
          }
        ];
      };
    };

    zsh = {
      enable = true;
      autocd = true;
      dotDir = ".config/zsh";
      enableCompletion = true;
      enableAutosuggestions = true;
      enableSyntaxHighlighting = true;
      defaultKeymap = "viins";
      shellAliases = aliases;
      initExtraBeforeCompInit = ''
              fpath=(~/.config/zsh/completion $fpath)
            '';
      # Plugins
      plugins = [
        # sfz-prompt
        {
          name = "sfz";
          src = builtins.fetchGit {
            url = "https://github.com/teu5us/sfz-prompt.zsh";
            rev = "1419b468675c367fa44cd14e1bf86997f2ada5fc";
          };
        }
        {
          name = "fzf-tab";
          src = builtins.fetchGit {
            url = "https://github.com/Aloxaf/fzf-tab";
            rev = "c5c6e1d82910fb24072a10855c03e31ea2c51563";
          };
        }
      ];
      initExtra = ''
              # Emacs tramp fix
              if [[ "$TERM" == "dumb" ]]
              then
                unsetopt zle
                unsetopt prompt_cr
                unsetopt prompt_subst
                # unfunction precmd
                # unfunction preexec
                export PS1='$ '
              fi

              bindkey '^F' autosuggest-accept
              bindkey '^G' toggle-fzf-tab

              # indicate mode by cursor shape
              zle-keymap-select () {
              if [ $KEYMAP = vicmd ]; then
                  printf "\033[2 q"
              else
                  printf "\033[6 q"
              fi
                              }
              zle-line-init () {
                  zle -K viins
                  printf "\033[6 q"
                              }
              zle-line-finish () {
                  printf "\033[2 q"
                              }
              zle -N zle-keymap-select
              zle -N zle-line-init
              zle -N zle-line-finish

              DISABLE_AUTO_TITLE="true"

              function precmd() {
                # echo -en "\e]2;$@\a"
                print -Pn "\e]0;%~\a"
              }
            '';
    };

    autojump.enable = true;

    zoxide = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      defaultCommand = "fd --type f";
      defaultOptions = [ "--height 40%" "--prompt »" "--layout=reverse" ];
      fileWidgetCommand = "fd --type f";
      fileWidgetOptions = [ "--preview 'head {}'" ];
      changeDirWidgetCommand = "fd --type d";
      changeDirWidgetOptions = [ "--preview 'tree -C {} | head -200'" ];
      # historyWidgetCommand = "history";
      # historyWidgetOptions = [ ];
      enableBashIntegration = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      enableBashIntegration = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
    };

    mpv = {
      enable = true;
      config = {
        vo = "gpu";
        hwdec = "auto-safe";
        profile = "gpu-hq";
        hwdec-codecs = "all";
        sub-font-size = "22";
      };
      bindings = {
        "l" = "seek 5";
        "h" = "seek -5";
        "j" = "seek -60";
        "k" = "seek 60";
        "S" = "cycle sub";
      };
    };
  };

  services = {
    ss.enable = true;
    ss.configFile = "${config.home.homeDirectory}/ss.json";
    emacs = {
      enable = true;
      package = config.programs.emacs.finalPackage;
      client = {
        enable = true;
        arguments = [ "-c" "-a" "''" ];
      };
      socketActivation.enable = true;
    };

    clipmenu.enable = false;

    syncthing = {
      enable = true;
    };

    picom = {
      enable = true;
      blur = true;
      vSync = true;
    };

    unclutter = {
      enable = true;
      extraOptions = [ "ignore-scrolling" ];
    };

    udiskie = {
      enable = true;
      tray = "auto";
      automount = false;
      notify = true;
    };
  };

  xsession = {
    enable = true;
    windowManager.command = "exwm";
    scriptPath = ".xinitrc";
    initExtra = ''
      ${pkgs.xorg.xrdb}/bin/xrdb -merge ~/.Xresources &
      ${pkgs.feh}/bin/feh --bg-scale ~/.config/wall.jpg &
      ${pkgs.numlockx}/bin/numlockx &
    '' + lib.optionalString (xsession.windowManager.command == "exwm") ''
      export XMODIFIERS=@im=exwm-xim
      export GTK_IM_MODULE=xim
      export QT_IM_MODULE=xim
      export CLUTTER_IM_MODULE=xim
    '';
  };

  gtk = {
    enable = true;
    theme = {
      package = pkgs.whitesur-gtk-theme;
      name = "WhiteSur-dark";
    };
    iconTheme = {
      package = pkgs.papirus-icon-theme;
      name = "Papirus-Dark";
    };
    gtk2.extraConfig = ''
            gtk-key-theme-name="Emacs"
          '';
    gtk3.extraConfig = { gtk-key-theme-name = "Emacs";
                         gtk-primary-button-warps-slider = "false";
                       };
  };

  # qt = {
  #   enable = true;
  #   style = "adwaita-dark";
  #   platformTheme = "gnome";
  # };

  home = rec {
    username = "paul";
    homeDirectory = "/home/${username}";

    pointerCursor = {
      package = pkgs.numix-cursor-theme;
      name = "Numix-Cursor-Light";
      size = 28;
      gtk.enable = true;
      x11.enable = true;
      x11.defaultCursor = "left_ptr";
    };

    keyboard = {
      layout = "us,ru";
      variant = ",";
      options = [ "grp:shifts_toggle" ];
    };

    packages = with pkgs; [
      anydesk
      appimage-run
      discord
      freerdp
      gnome.gnome-tweaks
      keepassxc
      libreoffice-fresh
      maim
      openvpn
      pandoc
      inputs.nixpkgs-unstable.legacyPackages.x86_64-linux.poetry
      pulsemixer
      remmina
      skypeforlinux
      syncthing
      tdesktop
      tmate
      tmux
      xcalib
      yandex-disk
      zoom-us
      exwm
      e
      nvim
      vscode-fhs
      # (pkgs.vscode-with-extensions.override {
      #   vscodeExtensions = (with pkgs.vscode-extensions; [
      #     vscodevim.vim
      #     bbenoist.nix
      #     ms-python.python
      #     ms-python.vscode-pylance
      #     ms-toolsai.jupyter
      #     justusadam.language-haskell
      #     haskell.haskell
      #     dracula-theme.theme-dracula
      #     zhuangtongfa.material-theme
      #     ms-vscode-remote.remote-ssh
      #   ]) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
      #     {
      #       name = "vscode-direnv";
      #       publisher = "cab404";
      #       version = "1.0.0";
      #       sha256 = "sha256-+nLH+T9v6TQCqKZw6HPN/ZevQ65FVm2SAo2V9RecM3Y=";
      #     }
      #     {
      #       name = "syntax-highlighter";
      #       publisher = "evgeniypeshkov";
      #       version = "0.5.0";
      #       sha256 = "sha256-2XUuI90rVnC8pRUgAOPw3wHa3GcnuGIr2U/qTCn3dKA=";
      #     }
      #     {
      #       name = "vscode-javascript-repl";
      #       publisher = "achil";
      #       version = "0.7.3";
      #       sha256 = "sha256-1hwiQPKdZdzTD1VfSiV06IKIat7YdYRC+Fhq0cLs0aA=";
      #     }
      #     {
      #       name = "color-highlight";
      #       publisher = "naumovs";
      #       version = "2.5.0";
      #       sha256 = "sha256-dYMDV84LEGXUjt/fbsSy3BVM5SsBHcPaDDll8KjPIWY=";
      #     }
      #     {
      #       name = "es7-react-js-snippets";
      #       publisher = "rodrigovallades";
      #       version = "1.9.3";
      #       sha256 = "sha256-bEYzrfFUIjaY15VenUsvT5Qr1BqNBUvzyYXi4+GiOKM=";
      #     }
      #     {
      #       name = "JavaScriptSnippets";
      #       publisher = "xabikos";
      #       version = "1.8.0";
      #       sha256 = "sha256-ht6Wm1X7zien+fjMv864qP+Oz4M6X6f2RXjrThURr6c=";
      #     }
      #     {
      #       name = "ts-extension-pack";
      #       publisher = "loiane";
      #       version = "0.3.0";
      #       sha256 = "sha256-W1/S2b0J0ptweVd18DxH9B+13Ca4zwfKRE8F+OJ5J2w=";
      #     }
      #     {
      #       name = "typescript-explorer";
      #       publisher = "mxsdev";
      #       version = "0.3.3";
      #       sha256 = "sha256-UqLx9+Se7tdRaZ2DquOrE1H8II2wa6ZfeGT0KXBiTA4=";
      #     }
      #   ];
      # })
    ]
    ++ lib.optionals (xsession.windowManager.command == "exwm") [
      gnome.sushi
      gnome.nautilus
    ];

    file = {
      ".inputrc".text = ''
              set editing-mode vi
              set keymap vi-command
            '';

      ".tmux.conf".source = ./files/tmux.conf;
      ".tmate.conf".source = ./files/tmate.conf;
      ".xmobarrc".source = ../../../modules/gui/files/xmobarrc;
    };
  };
}
