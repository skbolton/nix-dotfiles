{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.synology;
in
{
  options.delta.synology = with types; {
    enable = mkEnableOption "synology drive";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.synology-drive-client ];
    xdg.autostart.entries = [
      "${pkgs.synology-drive-client}/share/applications/synology-drive.desktop"
    ];
  };
}
