({ config, pkgs, options, lib, ... }: {
  services.yggdrasil = {
    enable = true;
    persistentKeys = true;
    config = {
      Peers = [
        "tls://yggpvs.duckdns.org:8443"
        "tcp://92.124.136.131:30111"
        "tcp://188.225.9.167:18226"
        "tls://yggno.de:18227"
        "tcp://yggno.de:18226"
        "tcp://95.165.99.73:5353"
        "tcp://188.225.9.167:18226"
      ];
    };
  };
})
