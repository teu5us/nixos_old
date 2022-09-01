{ config, pkgs, options, lib, ... }:

{
  services.xserver.windowManager.xmonad = {
    enable = false;
    enableContribAndExtras= true;
    config = builtins.readFile ./files/xmonad.hs;
  };
  environment.systemPackages = lib.optional
    config.services.xserver.windowManager.xmonad.enable
    pkgs.xmobar;
}
