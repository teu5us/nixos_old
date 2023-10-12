{ config, lib, pkgs, ... }:

with lib;

let
  cfg = config.services.ss;
in {
  options = {
    services.ss = {
      enable = mkOption {
        default = false;
        type = types.bool;
        description = ''
          Run `ss-local` on startup.
        '';
      };

      configFile = mkOption {
        default = "$HOME/ss.json";
        type = types.str;
        description = ''
          Config file for shadowsocks.
        '';
      };
    };
  };

  config = mkIf cfg.enable {
    systemd.user.services.shadowsocks-client = {
      Unit = {
        Description = "Run shadowsocks client.";
        After = [ "graphical-session-pre.target" ];
        PartOf = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.shadowsocks-libev}/bin/ss-local -c ${cfg.configFile}";
      };

      Install.WantedBy = [ "graphical-session.target" ];
    };
  };
}
