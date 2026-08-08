{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.delta.notes;
in
{
  options.delta.notes = {
    enable = lib.mkEnableOption "Notes";
    notebook_dir = lib.mkOption {
      type = lib.types.str;
      description = "Primary nootbook root";
      default = "$HOME/Notes";
      example = "$HOME/Notes";
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      JOURNALS = "$HOME/Documents/Logbook/Journal";
      ZK_NOTEBOOK_DIR = cfg.notebook_dir;
    };

    home.packages = with pkgs; [
      zk
      delta.qke
      delta.dsearch
      delta.weekp
      delta.dweek
      delta.dyear
      delta.dmonth
      delta.cosma
    ];

    xdg.configFile."zk/config.toml".source = ./zk.toml;
  };

}
