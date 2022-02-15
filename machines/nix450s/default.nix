{ config, pkgs, options, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hardware.nix
    ./kernel.nix
    ../../modules/base
    ../../modules/shell
    ../../modules/security
    ../../modules/network
    ../../modules/network/manual-openvpn.nix
    ../../modules/virtualization
    ../../modules/gui
    ../../users/paul
    ../../containers/pgsql
  ];

  networking.hostName = "nix450s"; # Define your hostname.

  boot.kernelPackages = pkgs.linuxPackages_5_16;

  fileSystems = {
    "/".options = [ "noatime" "nodiratime" "discard" ];
    "/home".options = [ "noatime" "nodiratime" "discard" ];
  };

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/9d967617-5ad2-45c4-9dc8-b4c6ca3191a6";
      preLVM = true;
      allowDiscards = true;
    };
    home = {
      device = "/dev/disk/by-uuid/8953056d-b75f-4907-ae30-558cbc853657";
      preLVM = true;
      allowDiscards = true;
    };
  };

  services.kmonad = {
    enable = true;
    configfiles = [ ./files/kmonad-keymap-emacs.kbd ];
  };

  system.stateVersion = "21.11";

  system.nixos.tags = [ "FLAKE" ];
}
