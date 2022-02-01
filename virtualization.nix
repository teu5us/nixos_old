{ config, pkgs, options, lib, ... }:

{
  virtualisation = {
    # libvirtd
    libvirtd = {
      enable = true;
      onShutdown = "shutdown";
      qemu = {
        ovmf = {
          enable = true;
          package = pkgs.OVMFFull;
        };
        swtpm = {
          enable = true;
          package = pkgs.swtpm-secureBoot;
        };
        verbatimConfig = ''
          user = "paul"
          group = "libvirtd"
        '';
      };
    };
    spiceUSBRedirection.enable = true;
    # Docker
    docker.enable = true;
  };
}
