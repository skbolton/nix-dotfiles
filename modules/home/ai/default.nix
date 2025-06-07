{ lib, config, inputs, pkgs, ... }:
let
  cfg = config.delta.ai;
in
with lib;
{
  options.delta.ai = with types; {
    enable = mkEnableOption "ai";
  };

  config = mkIf cfg.enable {

    home.sessionVariables.AICHAT_CONFIG_FILE = "$HOME/.config/sops-nix/secrets/aichat-config";

    home.packages = with pkgs; [
      aichat
    ];

    programs.tmux.extraConfig = /* tmux */ ''
      bind C-a split-window -h -l 33% aichat 
    '';

    xdg.configFile."aichat/dark.tmTheme".source = inputs.embark-bat-theme + "/Embark.tmTheme";
  };
}
