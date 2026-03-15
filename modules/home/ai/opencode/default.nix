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
    programs.opencode = {
      enable = true;
      package = inputs.opencode.packages.${pkgs.stdenv.hostPlatform.system}.default;
      settings.theme = "embark";
      settings.model = "zionlab/MiniMax-M2";
      settings.mcp = cfg.mcp;
      themes.embark = {
        defs = {
          space0 = "#100E23";
          space1 = "#1e1c31";
          space2 = "#2d2a4a";
          space3 = "#3E3859";
          space4 = "#585273";
          astral0 = "#8A889D";
          astral1 = "#cbe3e7";
          red = "#F48FB1";
          dark_red = "#F02E6E";
          green = "#A1EFD3";
          dark_green = "#7fe9c3";
          yellow = "#ffe6b3";
          dark_yellow = "#F2B482";
          blue = "#91ddff";
          dark_blue = "#78a8ff";
          purple = "#d4bfff";
          dark_purple = "#7676ff";
          cyan = "#ABF8F7";
          dark_cyan = "#63f2f1";
          diff_add = "#2D5059";
          diff_del = "#5E3859";
          diff_changed = "#38325A";
        };
        theme = {
          primary = "green";
          secondary = "purple";
          accent = "cyan";
          error = "red";
          warning = "yellow";
          success = "green";
          info = "blue";
          text = "astral1";
          textMuted = "astral0";
          background = "space0";
          backgroundPanel = "space1";
          backgroundElement = "space1";
          border = "cyan";
          borderActive = "space3";
          borderSubtle = "yellow";
          diffAdded = "green";
          diffRemoved = "red";
          diffContext = "space1";
          diffHunkHeader = "space1";
          diffHighlightAdded = "green";
          diffHighlightRemoved = "red";
          diffAddedBg = "diff_add";
          diffRemovedBg = "diff_del";
          diffContextBg = "diff_changed";
          diffLineNumber = "space1";
          diffAddedLineNumberBg = "space1";
          diffRemovedLineNumberBg = "space1";
          markdownText = "astral1";
          markdownHeading = "dark_blue";
          markdownLink = "purple";
          markdownLinkText = "cyan";
          markdownCode = "green";
          markdownBlockQuote = "space3";
          markdownEmph = "yellow";
          markdownStrong = "astral1";
          markdownHorizontalRule = "space3";
          markdownListItem = "cyan";
          markdownListEnumeration = "cyan";
          markdownImage = "purple";
          markdownImageText = "cyan";
          markdownCodeBlock = "astral1";
          syntaxComment = "space4";
          syntaxKeyword = "purple";
          syntaxFunction = "red";
          syntaxVariable = "cyan";
          syntaxString = "green";
          syntaxNumber = "dark_yellow";
          syntaxType = "purple";
          syntaxOperator = "dark_blue";
          syntaxPunctuation = "astral1";
        };
      };
      settings.keybinds = {
        input_newline = "return";
        input_submit = "ctrl+y";
      };
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
            tools = true;
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
  };
}
