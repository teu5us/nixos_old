{ config, pkgs, options, lib, ... }:

{
  services.xserver.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras= true;
    config = builtins.readFile ./files/xmonad.hs;
  };
}
