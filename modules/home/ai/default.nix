{ lib, config, pkgs, ... }:
let
  cfg = config.delta.ai;
in
with lib;
{
  options.delta.ai = with types; {
    enable = mkEnableOption "ai";
    aichat_theme = mkOption {
      type = enum [ "light" "dark" ];
      default = "dark";
    };
  };

  config = mkIf cfg.enable {

    home.sessionVariables = {
      AICHAT_ENV_FILE = "$HOME/.config/sops-nix/secrets/aichat-env";
      AICHAT_CONFIG_DIR = "$HOME/.config/aichat";
    };

    home.packages = with pkgs; [
      unstable.aichat
      unstable.opencode
    ];

    programs.tmux.extraConfig = /* tmux */ ''
      bind C-a new-window 'nvim +"set ft=markdown" $(mktemp)'
    '';

    xdg.configFile."aichat/config.yaml".text = (generators.toYAML { } {
      theme = cfg.aichat_theme;
      clients = [
        {
          type = "openai-compatible";
          name = "Zionlab";
          api_base = "https://ollama-api.zionlab.online/v1";
          models = [
            { name = "qwen3-coder:30b-a3b"; }
            { name = "gpt-oss:120b"; }
            { name = "llama3.2:3b"; }
          ];
        }
      ];
    });

    xdg.configFile."aichat/roles" = {
      source = ./aichat/roles;
      recursive = true;
    };

    programs.zsh.initContent = lib.mkOrder
      1200
      ''
        _aichat_zsh_suggest() {
          if [[ -n "$BUFFER" ]]; then
            local _old=$BUFFER
            BUFFER+=" 󰑓 "
            zle -I && zle redisplay
            BUFFER=$(aichat -r '%shell%' "$_old")
            zle end-of-line
          fi
        }

        _aichat_zsh_explain() {
          if [[ -n "$BUFFER" ]]; then
            BUFFER="aichat -e '"$BUFFER"'"
            zle accept-line
          fi
        }

        zle -N _aichat_zsh_suggest
        bindkey -M viins '^x' _aichat_zsh_suggest

        zle -N _aichat_zsh_explain
        bindkey -M viins '^X' _aichat_zsh_explain
      '';

    xdg.configFile."nvim/plugin/ai-grammar.lua".text = mkIf
      config.delta.neovim.enable /* lua */
      ''
        vim.keymap.set({'n', 'v'}, '<leader>ag', '!aichat -r grammar<CR>')
      '';
  };
}
