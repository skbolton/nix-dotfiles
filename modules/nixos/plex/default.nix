{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.delta.plex;
in
{
  options.delta.plex = with types; {
    enable = mkEnableOption "plex";
    package = mkPackageOption pkgs.unstable "plex";
    openFirewall = mkOption {
      type = bool;
      default = true;
    };
    dataDir = mkOption {
      type = str;
      default = "/var/lib/plex";
    };
  };

  config = mkIf cfg.enable {
    services.plex = {
      enable = cfg.enable;
      openFirewall = cfg.openFirewall;
      dataDir = cfg.dataDir;
    };

    systemd.tmpfiles.rules = with config.services.plex; [
      "d ${dataDir} 0755 ${user} ${group}"
    ];
  };
}

