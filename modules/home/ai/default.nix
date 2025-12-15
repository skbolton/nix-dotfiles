{ inputs, lib, config, pkgs, ... }:
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
      inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default
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
          api_base = "https://zaia.zionlab.online/v1";
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

    xdg.configFile."opencode/opencode.json".text = import ./opencode.nix;

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

        export $(xargs < "$HOME/.config/sops-nix/secrets/zaia-creds")
      '';

    xdg.configFile."nvim/plugin/ai-grammar.lua".text = mkIf
      config.delta.neovim.enable /* lua */
      ''
        vim.keymap.set({'n', 'v'}, '<leader>ag', '!aichat -r grammar<CR>')
        vim.keymap.set({'n', 'v'}, '<leader>ad', '!aichat -r dev ')
      '';

    programs.neovim.plugins = with pkgs.unstable.vimPlugins; [
      {
        plugin = minuet-ai-nvim;
        config = /* lua */ ''
          local Job = require 'plenary.job'

          require 'lz.n'.load {
            "minuet-ai.nvim",
            event = 'InsertEnter',
            after = function()
              require 'minuet'.setup {
              blink = { enable_auto_complete = false },
                virtualtext = {
                  auto_trigger_ft = {'*'},
                  auto_trigger_ignore_ft = {'markdown', 'txt'},
                  keymap = {
                    accept = '<TAB>',
                    accept_line = '<S-TAB>'
                  }
                },
                provider = 'openai_fim_compatible',
                provider_options = {
                  openai_fim_compatible = {
                    api_key = function() return 'UNUSED' end,
                    name = 'Zionlab',
                    end_point = "https://zaia.zionlab.online/v1/completions",
                    model = "qwen3-coder:30b-a3b",
                    template = {
                      prompt = function(context_before_cursor, context_after_cursor, _)
                        return '<|fim_prefix|>'
                            .. context_before_cursor
                            .. '<|fim_suffix|>'
                            .. context_after_cursor
                            .. '<|fim_middle|>'
                      end,
                      suffix = false,
                    },
                    transform = {
                      function (args)
                        args.headers["CF-Access-Client-Secret"] = os.getenv("ZAIA_CLIENT_SECRET")
                        args.headers["CF-Access-Client-Id"] = os.getenv("ZAIA_CLIENT_ID")

                        return args
                      end
                    }
                  }
                }
              }
            end
          }
        '';
        optional = true;
        type = "lua";
      }
    ];
  };
}
