{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.delta.habits;
in
{
  options.delta.habits = {
    enable = lib.mkEnableOption "habits";
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      HARSHPATH = "$HOME/Documents/Logbook/Trackers/Habits/$(date +%Y)";
    };
    programs.zsh.shellAliases = {
      hab = "harsh";
    };

    home.packages = with pkgs; [
      unstable.harsh
      (writeShellScriptBin "habits" ''
        echo "$HARSHPATH/log" | ${entr}/bin/entr -c harsh log
      '')
    ];
  };
}
