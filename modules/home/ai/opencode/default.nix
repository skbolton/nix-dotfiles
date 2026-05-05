{ inputs, lib, config, pkgs, ... }:
let
  cfg = config.delta.ai.opencode;
in
with lib;
{
  options.delta.ai.opencode = with types; {
    enable = mkOption {
      type = bool;
      default = config.delta.ai.enable;
      description = "Whether to enable opencode";
    };
    mcp = mkOption {
      type = types.attrsOf types.unspecified;
      default = { };
    };
    agent = mkOption {
      type = types.attrsOf (types.submodule {
        options = {
          mode = mkOption {
            type = enum [ "primary" "subagent" ];
          };
          model = mkOption {
            type = str;
          };
          prompt = mkOption {
            type = str;
            default = "";
          };
          description = mkOption {
            type = str;
            default = "";
          };
          tools = mkOption {
            type = types.submodule {
              options = {
                write = mkOption {
                  type = bool;
                  default = false;
                };
                edit = mkOption {
                  type = bool;
                  default = false;
                };
                bash = mkOption {
                  type = bool;
                  default = false;
                };
              };
            };
            default = { };
          };
        };
      });
      default = { };
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ mpv ];
    programs.opencode = {
      enable = true;
      package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings.mcp = cfg.mcp;
      settings.agent = cfg.agent;
      settings.provider.zionlab = {
        npm = "@ai-sdk/openai-compatible";
        options = {
          baseURL = "https://zai.zionlab.online/api/v1";
          headers = {
            CF-Access-Client-Secret = "{env:ZAIA_CLIENT_SECRET}";
            CF-Access-Client-Id = "{env:ZAIA_CLIENT_ID}";
          };
        };
        models = {
          "qwen3-coder:30b-a3b" = {
            tools = true;
          };
          "MiniMax-M2" = {
            interleaved.field = "reasoning_content";
            reasoning = true;
            tool_call = true;
            cost = {
              input = 0.255;
              output = 1.02;
            };
          };
        };
      };
    };

    programs.git.ignores = [ ".opencode" ];

    xdg.configFile."opencode/agents" = {
      source = ./agents;
      recursive = true;
    };

    xdg.configFile."opencode/tui.json".text = builtins.toJSON {
      "$schema" = "https://opencode.ai/tui.json";
      keybinds = {
        input_newline = "return";
        input_submit = "ctrl+y";
      };
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
