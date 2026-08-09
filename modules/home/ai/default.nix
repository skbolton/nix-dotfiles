{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.delta.ai;
in
{
  options.delta.ai = {
    enable = lib.mkEnableOption "ai";
  };

  config = lib.mkIf cfg.enable {

    home.packages = with pkgs; [
      python3
    ];

    sops.secrets.zaia-creds.path = "%r/zaia-creds.txt";

    programs.tmux.extraConfig = /* tmux */ ''
      bind a switch-client -T ai
      bind -T ai a split -h -l 100 \; send opencode Enter
      bind -T ai g new-window 'nvim +"set ft=markdown" $(mktemp)'
      bind -T ai A new-window -n "󱚞 " opencode
    '';

    home.file.".agents/skills" = {
      source = ./skills;
      recursive = true;
    };

    programs.zsh.initContent = lib.mkOrder 1200 ''
      export $(xargs < "$HOME/.config/sops-nix/secrets/zaia-creds")
    '';

    xdg.configFile."nvim/plugin/mappings/ai.lua".source = lib.mkIf config.delta.neovim.enable ./ai.lua;

    programs.neovim.plugins = with pkgs.vimPlugins; [
      {
        plugin = minuet-ai-nvim;
        config = /* lua */ ''
          local Job = require 'plenary.job'

          require 'lz.n'.load {
            "minuet-ai.nvim",
            event = 'InsertEnter',
          enabled = false,
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
                    end_point = "https://zai.zionlab.online/v1/completions",
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
