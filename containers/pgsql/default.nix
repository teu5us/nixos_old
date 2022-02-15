{ config, pkgs, options, lib, ... }:

{
  containers.pgsql = {
    config = import ./config.nix;
    privateNetwork = true;
    forwardPorts = [
      { hostPort = 5432; }
    ];
  };
}
