{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.timetracking;
in
{
  options.delta.timetracking = with types; {
    enable = mkEnableOption "timetracking";
    timesheets = mkOption {
      type = str;
      description = "Directory where timesheets are stored";
      example = "$HOME/timesheets";
      default = "$HOME/timesheets";
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      hledger
      remind
    ];

    home.sessionVariables = {
      TIMESHEETS = cfg.timesheets;
    };

    programs.zsh = {
      shellAliases = {
        htime = "cat $TIMESHEETS/* | ${pkgs.hledger}/bin/hledger -f timeclock:- balance -t";
      };
    };
  };
}
