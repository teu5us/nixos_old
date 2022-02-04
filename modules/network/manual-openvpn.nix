{ config, pkgs, options, lib, ... }:

{
  environment.etc."openvpn/update-resolv-conf" = {
    source = "${pkgs.update-resolv-conf}/libexec/openvpn/update-resolv-conf";
    mode = "symlink";
  };
}
