{ config, pkgs, options, lib, ... }:

{
  imports = [ ./xmonad.nix ];
  services.xserver = {
    displayManager = {
      gdm.enable = true;
      gdm.wayland = false;
      defaultSession = "gnome-xorg";
    };
    desktopManager = {
      gnome.enable = true;
    };
  };

  environment.systemPackages = with pkgs.gnomeExtensions; [
    gnome-40-ui-improvements
    transparent-window-moving
    quake-mode
    clipboard-indicator
    blur-my-shell
    sound-output-device-chooser
    bluetooth-quick-connect
    tray-icons-reloaded
    unite
    floating-dock
    gsconnect
    pkgs.xmobar
  ];
}
