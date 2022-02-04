{ config, pkgs, options, lib, ... }:

{
  services.xserver = {
    displayManager.startx.enable = true;
    windowManager.xmonad = {
      enable = true;
      enableContribAndExtras= true;
      config = builtins.readFile ./files/xmonad.hs;
    };
  };
  programs.dconf.enable = true;
  environment.systemPackages = [
    pkgs.xmobar
  ];
}
