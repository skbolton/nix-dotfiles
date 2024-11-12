{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.timetracking;
in
{
  options.delta.timetracking = with types; {
    enable = mkEnableOption "timetracking";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hledger
      remind
    ];

    home.sessionVariables = {
      TIMECARDS = "$HOME/00-09-System/03-Quantified/03.10-Timecards/$(date +%Y)";
    };

    programs.zsh = {
      shellAliases = {
        htime = "cat $TIMECARDS/*.timeclock | ${pkgs.hledger}/bin/hledger -f timeclock:- balance -t";
      };
    };

  };
}
