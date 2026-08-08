{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.delta.synology;
in
{
  options.delta.synology = {
    enable = lib.mkEnableOption "synology drive";
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.synology-drive-client ];
    xdg.autostart.entries = [
      "${pkgs.synology-drive-client}/share/applications/synology-drive.desktop"
    ];
  };
}
