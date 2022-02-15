{ config, pkgs, options, lib, ... }:

{
  containers.pgsql = {
    config = import ./config.nix;
    privateNetwork = true;
    hostAddress = "10.233.1.1";
    localAddress = "10.233.1.2";
  };
}
