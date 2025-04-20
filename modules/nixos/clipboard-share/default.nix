{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.clipboard-share;
in
{
  options.delta.clipboard-share = with types; {
    enable = mkEnableOption "clipboard-share";
    type = mkOption { type = enum [ "client" "server" ]; };

    server = mkOption {
      type = submodule {
        options = {
          hostname = mkOption {
            type = str;
            description = "hostname without port for clipboard server";
          };
          port = mkOption {
            description = "Port server is running at";
            type = str;
            default = "11155";
          };
          user = lib.mkOption {
            description = "Unix User to run the server under";
            type = types.str;
            default = "clipboard-share";
          };
          group = lib.mkOption {
            description = "Unix Group to run the server under";
            type = types.str;
            default = "clipboard-share";
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [ pkgs.delta.uniclip ];

    users.users.${cfg.server.user} = {
      isSystemUser = true;
      inherit (cfg.server) group;
    };
    users.groups.${cfg.server.group} = { };

    networking.firewall.allowedTCPPorts = mkIf (cfg.type == "server") [ cfg.server.port ];

    systemd.services.clipboard-share-server = mkIf (cfg.type == "server") {
      wantedBy = [ "multi-user.target" ];
      after = [ "network.target" ];
      serviceConfig = {
        User = cfg.server.user;
        Group = cfg.server.group;
        DynamicUser = false;
        ExecStart = "${pkgs.delta.uniclip}/bin/uniclip -p ${cfg.server.port}";
      };
    };

    systemd.user.services.clipboard-share = mkIf (cfg.type == "client") {
      enable = true;
      after = [ "network.target" ];
      description = "Clipboard Share client connection";
      serviceConfig = {
        ExecStart = "${pkgs.delta.uniclip}/bin/uniclip ${cfg.server.hostname}:${cfg.server.port}";
      };
    };
  };
}







