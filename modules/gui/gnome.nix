{ config, pkgs, options, lib, ... }:

{
  services.xserver = {
    displayManager = {
      gdm.enable = true;
      defaultSession = "gnome-xorg";
    };
    desktopManager = {
      gnome.enable = true;
    };
  };
}
