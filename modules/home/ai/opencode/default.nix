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
    home.packages = [ pkgs.mpv ];
    programs.opencode = {
      enable = true;
      package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings.autoupdate = false;
      settings.formatter = true;
      context = ../AGENTS.md;
      settings.mcp = cfg.mcp;
      settings.plugin = [ "opentmux" ];
      settings.agent = cfg.agent;
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
