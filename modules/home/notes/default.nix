{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.notes;
in
{
  options.delta.notes = with types; {
    enable = mkEnableOption "Notes";
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      JOURNALS = "$HOME/Documents/Logbook/Journal";
      ZK_NOTEBOOK_DIR = "$HOME/Documents/Reference";
    };

    home.packages = with pkgs; [
      logseq
      obsidian
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
