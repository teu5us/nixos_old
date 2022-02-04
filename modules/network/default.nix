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

    # Configure network proxy if necessary
    # proxy.default = "localhost:8118";
    # proxy.noProxy = "127.0.0.1,localhost,internal.domain";
    # Open ports in the firewall.
    firewall.allowedTCPPorts = [ 22 3020 5432 ];
    # firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    firewall.enable = true;
  };
}
