{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.delta.ai.opencode;
in
{
  options.delta.ai.opencode = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = config.delta.ai.enable;
      description = "Whether to enable opencode";
    };
    mcp = lib.mkOption {
      type = lib.types.attrsOf lib.types.unspecified;
      default = { };
    };
    agent = lib.mkOption {
      type = lib.types.attrsOf (
        lib.types.submodule {
          options = {
            mode = lib.mkOption {
              type = lib.types.enum [
                "primary"
                "subagent"
              ];
            };
            model = lib.mkOption {
              type = lib.types.str;
            };
            prompt = lib.mkOption {
              type = lib.types.str;
              default = "";
            };
            description = lib.mkOption {
              type = lib.types.str;
              default = "";
            };
            tools = lib.mkOption {
              type = lib.types.submodule {
                options = {
                  write = lib.mkOption {
                    type = lib.types.bool;
                    default = false;
                  };
                  edit = lib.mkOption {
                    type = lib.types.bool;
                    default = false;
                  };
                  bash = lib.mkOption {
                    type = lib.types.bool;
                    default = false;
                  };
                };
              };
              default = { };
            };
          };
        }
      );
      default = { };
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.mpv ];
    programs.opencode = {
      enable = true;
      package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings.autoupdate = false;
      settings.formatter = true;
      settings.default_agent = "dewey";
      context = ./GLOBAL_AGENTS.md;
      settings.mcp = cfg.mcp;
      settings.plugin = [ "opentmux" ];
      settings.agent = cfg.agent // {
        build = {
          disable = true;
        };
        plan = {
          disable = true;
        };
        explore = {
          disable = true;
        };
      };
      settings.permission = {
        external_directory = {
          "~/.config/opencode/**" = "allow";
        };
        edit = {
          "~/.config/opencode/**" = "ask";
        };
      };
      settings.references.agents = {
        path = "~/c/nix-dotfiles/modules/home/ai/opencode/agents";
        description = "Where ai agents are defined in case improvements or modifications need to be made";
      };
      settings.provider.zionlab = {
        name = "Zionlab";
        npm = "@ai-sdk/openai-compatible";
        options = {
          baseURL = "https://zai.zionlab.online/api/v1";
          headers = {
            CF-Access-Client-Secret = "{env:ZAIA_CLIENT_SECRET}";
            CF-Access-Client-Id = "{env:ZAIA_CLIENT_ID}";
          };
        };
        models = {
          "Delta" = {
            reasoning = true;
            tool_call = true;
            cost = {
              input = 1.10;
              output = 5.50;
            };
          };
          "Qwen3.6-35B-A3B-MTP-think" = {
            reasoning = true;
            tool_call = true;
            cost = {
              input = 0;
              output = 0;
            };
          };
          "Mira" = {
            interleaved.field = "reasoning_content";
            reasoning = true;
            tool_call = true;
            cost = {
              input = 1.10;
              output = 5.50;
            };
          };
        };
      };
      tui.keybinds = {
        input_newline = "return";
        input_submit = "ctrl+y";
      };
    };

    programs.git.ignores = [ ".opencode" ];

    xdg.configFile."opencode/agents" = {
      source = ./agents;
      recursive = true;
    };

    xdg.configFile."opencode/workflows" = {
      source = ./workflows;
      recursive = true;
    };

    xdg.configFile."opencode/boop.mp3".source = ./boop.mp3;

    xdg.configFile."opencode/plugins/alert.js".text = /* js */ ''
      export const NotificationPlugin = async ({ project, client, $, directory, worktree }) => {
        return {
          event: async ({ event }) => {
            // Send notification on session completion
            if (event.type === "session.idle") {
              await $`mpv '~/.config/opencode/boop.mp3' > /dev/null`
            }
          },
        }
      }
    '';
  };
}
