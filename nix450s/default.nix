{ config, pkgs, options, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./hardware.nix
    ./general.nix
    ./shell.nix
    ./security.nix
    ./network.nix
    ./manual-openvpn.nix
    ./virtualization.nix
    ./gui.nix
    ./db.nix
    ./kernel.nix
    ../hm/paul/default.nix
  ];

  networking.hostName = "nix450s"; # Define your hostname.

  boot.kernelPackages = pkgs.linuxPackages_5_4;

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
    configfiles = [ ./nix450s/kmonad-keymap-emacs.kbd ];
  };

  system.stateVersion = "21.11";

  system.nixos.tags = [ "FLAKE" ];
}
