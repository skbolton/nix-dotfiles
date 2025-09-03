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

    home.sessionVariables = {
      AICHAT_CONFIG_FILE = "$HOME/.config/sops-nix/secrets/aichat-config";
      AICHAT_ROLES_DIR = "$HOME/.config/aichat/roles";
    };

    home.packages = with pkgs; [
      aichat
      unstable.opencode
    ];

    programs.tmux.extraConfig = /* tmux */ ''
      bind C-a split-window -h -l 33% aichat 
    '';

    xdg.configFile."aichat/dark.tmTheme".source = inputs.embark-bat-theme + "/Embark.tmTheme";
    xdg.configFile."aichat/roles" = {
      source = ./aichat/roles;
      recursive = true;
    };

    programs.zsh.initContent = lib.mkOrder 1200 ''
      _aichat_zsh() {
        if [[ -n "$BUFFER" ]]; then
          local _old=$BUFFER
          BUFFER+="  🤔"
          zle -I && zle redisplay
          BUFFER=$(aichat -e "$_old")
          zle end-of-line
        fi
      }
      zle -N _aichat_zsh
      bindkey '^e' _aichat_zsh
    '';

    xdg.configFile."nvim/plugin/ai-grammar.lua".text = mkIf config.delta.neovim.enable /* lua */ ''
      vim.keymap.set({'n', 'v'}, '<leader>ag', '!aichat -r grammar<CR>')
    '';

    xdg.configFile."opencode/opencode.json".source = ./opencode.json;
  };
}
