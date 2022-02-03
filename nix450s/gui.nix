{ config, pkgs, options, lib, ... }:

{
  services = {
    xserver = {
      enable = true;
      autorun = true;
      autoRepeatDelay = 300;
      autoRepeatInterval = 50;
      layout = "us,ru";
      xkbVariant = ",";
      xkbOptions = "grp:shifts_toggle";
      # xkbOptions = "lv3:ralt_switch, grp_led:caps, caps:super";
      inputClassSections = [
        ''
          Identifier "Logitech MX Ergo"
          MatchProduct "MX Ergo Mouse"
          MatchIsPointer "on"
          # MatchDevicePath "/dev/input/event*"
          Driver "evdev"
          Option "SendCoreEvents" "true"
          Option "EmulateWheel" "true"
          Option "EmulateWheelButton" "2"
          Option "XAxisMapping" "6 7"
          Option "YAxisMapping" "4 5"
          Option "AccelerationProfile" "2"
          Option "AccelerationThreshold" "0"
          Option "AccelerationNumerator" "5"
          Option "AccelerationDenominator" "2"
          Option "AdaptiveDeceleration" "2"
          Option "VelocityScale" "3"
        ''
        ''
          Identifier "Logitech MX Ergo"
          MatchProduct "Logitech MX Ergo"
          MatchIsPointer "on"
          # MatchDevicePath "/dev/input/event*"
          Driver "evdev"
          Option "SendCoreEvents" "true"
          Option "EmulateWheel" "true"
          Option "EmulateWheelButton" "2"
          Option "XAxisMapping" "6 7"
          Option "YAxisMapping" "4 5"
          Option "AccelerationProfile" "2"
          Option "AccelerationThreshold" "0"
          Option "AccelerationNumerator" "5"
          Option "AccelerationDenominator" "2"
          Option "AdaptiveDeceleration" "2"
          Option "VelocityScale" "3"
        ''
        ''
          Identifier "Kensington Expert Mouse"
          MatchProduct "Kensington Expert Mouse"
          MatchIsPointer "on"
          # MatchDevicePath "/dev/input/event*"
          Driver "evdev"
          Option "SendCoreEvents" "true"
          Option "ButtonMapping" "1 8 3 4 5 6 7 2"
          Option "EmulateWheel" "false"
          Option "EmulateWheelButton" "0"
          Option "EmulateWheelInertia" "30"
          # Option "DragLockButtons" "2 1"
          Option "XAxisMapping" "6 7"
          Option "YAxisMapping" "4 5"
          Option "AccelerationProfile" "0"
          Option "AccelerationThreshold" "0"
          Option "AccelerationNumerator" "6"
          Option "AccelerationDenominator" "2"
          Option "AdaptiveDeceleration" "1"
          Option "VelocityScale" "3"
        ''
        ''
          Identifier "Kensington Slimblade Trackball"
          MatchProduct "Kensington Slimblade Trackball"
          MatchIsPointer "on"
          # MatchDevicePath "/dev/input/event*"
          Driver "evdev"
          Option "SendCoreEvents" "true"
          Option "ButtonMapping" "1 8 3 4 5 6 7 2"
          Option "EmulateWheel" "false"
          Option "EmulateWheelButton" "0"
          Option "EmulateWheelInertia" "30"
          # Option "DragLockButtons" "2 1"
          Option "XAxisMapping" "6 7"
          Option "YAxisMapping" "4 5"
          Option "AccelerationProfile" "2"
          Option "AccelerationThreshold" "0"
          Option "AccelerationNumerator" "6"
          Option "AccelerationDenominator" "2"
          Option "AdaptiveDeceleration" "3"
          Option "VelocityScale" "2"
        ''
        ''
          Identifier "ELECOM TrackBall Mouse HUGE TrackBall"
          MatchProduct "ELECOM TrackBall Mouse HUGE TrackBall"
          MatchIsPointer "on"
          Driver "evdev"
          Option "SendCoreEvents" "true"
          Option "EmulateWheel" "true"
          Option "EmulateWheelButton" "9"
          Option "EmulateWheelInertia" "20"
          Option "XAxisMapping" "6 7"
          Option "YAxisMapping" "4 5"
          Option "AccelerationProfile" "2"
          Option "AccelerationThreshold" "0"
          Option "AccelerationNumerator" "5"
          Option "AccelerationDenominator" "2"
          Option "AdaptiveDeceleration" "3"
          Option "VelocityScale" "1"
          Option "DragLockButtons" "12 1"
        ''
        ''
          Identifier "TPPS/2 IBM TrackPoint"
          MatchProduct "TPPS/2 IBM TrackPoint"
          MatchIsPointer "on"
          Driver "evdev"
          Option "SendCoreEvents" "true"
          # Option "AccelSpeed" "-0.35"
        ''
        ''
          Identifier "ELECOM TrackBall Mouse DEFT Pro TrackBall"
          MatchProduct "ELECOM TrackBall Mouse DEFT Pro TrackBall"
          MatchIsPointer "on"
          Driver "evdev"
          Option "SendCoreEvents" "true"
          Option "EmulateWheel" "true"
          Option "EmulateWheelButton" "9"
          Option "EmulateWheelInertia" "20"
          Option "XAxisMapping" "6 7"
          Option "YAxisMapping" "4 5"
          Option "AccelerationProfile" "2"
          Option "AccelerationThreshold" "0"
          Option "AccelerationNumerator" "5"
          Option "AccelerationDenominator" "2"
          Option "AdaptiveDeceleration" "3"
          Option "VelocityScale" "1.7"
          Option "DragLockButtons" "10"
        ''
        ''
          Identifier "DEFT Pro TrackBall"
          MatchProduct "DEFT Pro TrackBall"
          MatchIsPointer "on"
          Driver "evdev"
          Option "SendCoreEvents" "true"
          Option "EmulateWheel" "true"
          Option "EmulateWheelButton" "9"
          Option "EmulateWheelInertia" "20"
          Option "XAxisMapping" "6 7"
          Option "YAxisMapping" "4 5"
          Option "AccelerationProfile" "2"
          Option "AccelerationThreshold" "0"
          Option "AccelerationNumerator" "5"
          Option "AccelerationDenominator" "2"
          Option "AdaptiveDeceleration" "3"
          Option "VelocityScale" "1.7"
          Option "DragLockButtons" "10"
        ''
      ];
      displayManager = {
        # Enable startx
        startx.enable = false;
        gdm.enable = true;
        defaultSession = "gnome-xorg";
      };
      desktopManager = {
        gnome.enable = true;
      };
      videoDrivers = [ "modesetting" ];
      useGlamor = true;
      libinput = {
        enable = true;
        touchpad = {
          disableWhileTyping = true;
        };
      };
    };
  };

  fonts = {
    fonts = with pkgs; [
      opensans-ttf
      dejavu_fonts
      corefonts
      nerdfonts
      unifont
      joypixels
      roboto-mono
      google-fonts
      symbola
    ];
    fontconfig = {
      enable = true;
      hinting = {
        autohint = false;
        enable = true;
      };
      subpixel.lcdfilter = "default";
      antialias = true;
      includeUserConf = true;
      defaultFonts = {
        serif = [ "Tinos" ];
        sansSerif = [ "Arimo" ];
        monospace = [ "FiraCode Nerd Font" ];
      };
    };
  };

  environment.systemPackages = with pkgs; [
    xorg.setxkbmap xorg.xmodmap xorg.xkbcomp xorg.xset xautomation xdotool xorg.xdpyinfo xclip xorg.xev xorg.xhost xorg.xwininfo imwheel
  ];

  qt5 = {
    enable = true;
    style = "adwaita";
    platformTheme = "gnome";
  };
}
