{ config, pkgs, options, lib, ... }:

{
  networking = {
    useNetworkd = false;
    networkmanager = {
      enable = true; # Enable networkmanager
      extraConfig = ''
        [connection]
        ethernet.wake-on-lan = ignore
        wifi.wake-on-wlan = ignore
      '';
    };

    # The global useDHCP flag is deprecated, therefore explicitly set to false here.
    # Per-interface useDHCP will be mandatory in the future, so this generated config
    # replicates the default behaviour.
    useDHCP = false;
    interfaces.enp0s25.useDHCP = false;
    interfaces.wlp3s0.useDHCP = true;
    interfaces.enp0s25.mtu = 1492;
    interfaces.wlp3s0.mtu = 1492;

    interfaces.enp0s25.ipv4 = {
      addresses = [
        {
          address = "192.168.1.30";
          prefixLength = 24;
        }
      ];
    };

    # Configure network proxy if necessary
    # proxy.default = "localhost:8118";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    # Open ports in the firewall.
    firewall.allowedTCPPorts = [ 22 ];
    firewall.interfaces."lo".allowedTCPPorts = [ 1080 3020 4242 5432 ];
    firewall.interfaces."lo".allowedUDPPorts = [ 69 ];
    firewall.interfaces."enp0s25".allowedUDPPorts = [ 69 ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    firewall.enable = true;
  };

  services.tftpd = {
    enable = true;
    path = "/srv/tftp";
  };

  services.dhcpd4 = {
    enable = true;
    interfaces = [ "enp0s25" ];
    machines = [
      {
        ethernetAddress = "68:f7:28:6b:d7:d1";
        hostName = "nix450s";
        ipAddress = "192.168.1.30";
      }
    ];
    extraConfig = ''
      option subnet-mask 255.255.255.0;
      option broadcast-address 192.168.1.255;
      option routers 192.168.1.1;
      option voip-tftp-server code 150 = { ip-address };
      default-lease-time 600;
      max-lease-time 7200;
      subnet 192.168.1.0 netmask 255.255.255.0 {
        authoritative;
        range 192.168.1.1 192.168.1.100;
        option voip-tftp-server 192.168.1.30;
      }
    '';
  };
}
