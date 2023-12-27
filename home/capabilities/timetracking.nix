{ lib, pkgs, ...}:

{
  home.sessionVariables = {
    TIMECARDS = "$HOME/00-09-System/03-Quantified/03.10-Timecards/$(date +%Y)";
  };

  programs.zsh = {
    shellAliases = {
      htime = "cat $TIMECARDS/*.timeclock | ${pkgs.hledger}/bin/hledger -f timeclock:- balance -t";
    };
  };

  home.packages = with pkgs; [
    hledger
    remind
  ];
}
