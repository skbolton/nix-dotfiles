{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.delta.plex;
in
{
  options.delta.plex = {
    enable = lib.mkEnableOption "plex";
    package = lib.mkPackageOption pkgs.unstable "plex";
    openFirewall = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };
    dataDir = lib.mkOption {
      type = lib.types.str;
      default = "/var/lib/plex";
    };
  };

  config = lib.mkIf cfg.enable {
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
