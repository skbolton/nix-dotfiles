{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:

let
  cfg = config.delta.dev-null-theme;
in
{
  options.delta.dev-null-theme = {
    enable = lib.mkEnableOption "dev-null theme";
  };

  config = lib.mkIf cfg.enable {
    gtk.enable = true;
    stylix.enable = true;

    stylix.cursor = {
      size = 16;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
    };

    stylix.icons = {
      package = pkgs.fluent-icon-theme;
      dark = "Fluent-dark";
      light = "Fluent";
    };

    stylix.targets.neovim.enable = false;
    stylix.targets.tmux.enable = false;
    stylix.targets.fzf.enable = false;
    stylix.targets.starship.enable = false;
    stylix.targets.opencode.enable = false;

    programs.kitty.extraConfig = ''
      include ${./kitty-dev-null.conf}
    '';

    programs.fzf.colors = {
      # "bg+" = "#161616";
      "bg+" = "#141414";
      "fg" = "#6F6F6F";
      "fg+" = "#C6C6C6";
      "prompt" = "#3DDBD9";
      "header" = "#78A9FF";
      "pointer" = "#D4BBFF";
      "hl" = "#08BDBA";
      "hl+" = "#08BDBA";
      "spinner" = "#D4BBFF";
      "info" = "#4589FF";
      "border" = "#252525";
    };

    programs.neovim = {
      plugins = [
        {
          plugin = pkgs.vimUtils.buildVimPlugin {
            name = "dev-null-nvim";
            src = inputs.dev-null-theme;
          };
          config = /* lua */ ''
            vim.cmd("colorscheme dev-null")

            vim.api.nvim_set_hl(0, "@markup.heading.1", {  bg = "#120722", fg = "#a56eff" })
            vim.api.nvim_set_hl(0, "@neorg.headings.1.title", { link = "@markup.heading.1" })
            vim.api.nvim_set_hl(0, "@neorg.headings.1.prefix", { fg = "#a56eff" })
            vim.api.nvim_set_hl(0, "RenderMarkdownH1", { link = "@markup.heading.1" })
            vim.api.nvim_set_hl(0, "RenderMarkdownH1Bg", { link = "@markup.heading.1" })

            vim.api.nvim_set_hl(0, "@markup.heading.2", { bg = "#001031", fg = "#4589ff" })
            vim.api.nvim_set_hl(0, "@neorg.headings.2.title", { link = "@markup.heading.2" })
            vim.api.nvim_set_hl(0, "@neorg.headings.2.prefix", { fg = "#4589ff" })
            vim.api.nvim_set_hl(0, "RenderMarkdownH2", { link = "@markup.heading.2" })
            vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", { link = "@markup.heading.2" })

            vim.api.nvim_set_hl(0, "@markup.heading.3", { bg = "#001b1a", fg = "#009d9a" })
            vim.api.nvim_set_hl(0, "@neorg.headings.3.title", { link = "@markup.heading.3" })
            vim.api.nvim_set_hl(0, "@neorg.headings.3.prefix", { fg = "#009d9a" })
            vim.api.nvim_set_hl(0, "RenderMarkdownH3", { link = "@markup.heading.3" })
            vim.api.nvim_set_hl(0, "RenderMarkdownH3Bg", { link = "@markup.heading.3" })

            vim.api.nvim_set_hl(0, "@markup.heading.4", { bg = "#1a2300", fg = "#d5ff5e" })
            vim.api.nvim_set_hl(0, "@neorg.headings.4.title", { link = "@markup.heading.4" })
            vim.api.nvim_set_hl(0, "@neorg.headings.4.prefix", { fg = "#d5ff5e" })
            vim.api.nvim_set_hl(0, "RenderMarkdownH4", { link = "@markup.heading.4" })
            vim.api.nvim_set_hl(0, "RenderMarkdownH4Bg", { link = "@markup.heading.4" })

            vim.api.nvim_set_hl(0, "@markup.heading.5", { bg = "#1a2300", fg = "#d5ff5e" })
            vim.api.nvim_set_hl(0, "@neorg.headings.5.title", { link = "@markup.heading.5" })
            vim.api.nvim_set_hl(0, "@neorg.headings.5.prefix", { fg = "#d5ff5e" })
            vim.api.nvim_set_hl(0, "RenderMarkdownH5", { link = "@markup.heading.5" })
            vim.api.nvim_set_hl(0, "RenderMarkdownH5Bg", { link = "@markup.heading.5" })

            vim.api.nvim_set_hl(0, "@markup.heading.6", { bg = "#1a2300", fg = "#d5ff5e" })
            vim.api.nvim_set_hl(0, "@neorg.headings.6.title", { link = "@markup.heading.6" })
            vim.api.nvim_set_hl(0, "@neorg.headings.6.prefix", { fg = "#d5ff5e" })
            vim.api.nvim_set_hl(0, "RenderMarkdownH6", { link = "@markup.heading.6" })
            vim.api.nvim_set_hl(0, "RenderMarkdownH6Bg", { link = "@markup.heading.6" })

            vim.api.nvim_set_hl(0, "Folded", { bg = "#171522", fg = "#3d2f59" })

            vim.api.nvim_set_hl(0, "Normal", { bg = "#141414" })
            vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1B1B1B" })
            vim.api.nvim_set_hl(0, "ColorColumn", { bg = "#252525" })
            vim.api.nvim_set_hl(0, "@markup.list.unchecked", { bold = true, fg = "#d5ff5e" })
            vim.api.nvim_set_hl(0, "@markup.list.checked", { link = "Comment"})
            vim.api.nvim_set_hl(0, "@text.strong", { bold = true })
            vim.api.nvim_set_hl(0, "MatchParen", { fg = "#d9fbfb" })
            vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#173634" })
            vim.api.nvim_set_hl(0, "DiffChange", { link = "DiffAdd" })
            vim.api.nvim_set_hl(0, "DiffText", { bg = "#173634", bold = true })
            vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#2b1828", fg = "#9f1853" })
            -- vim.api.nvim_set_hl(0, "StatusLine", { bg = "#161616" })
            vim.api.nvim_set_hl(0, "StatusLine", { bg = "#141414" })
            -- vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#161616" })
            vim.api.nvim_set_hl(0, "StatusLineNC", { bg = "#141414" })
            vim.api.nvim_set_hl(0, "CursorColumn", { link = "CursorLine"})
            vim.api.nvim_set_hl(0, "DiagnosticWarn", { fg = "#d5ff5e"})
            vim.api.nvim_set_hl(0, "SpecialChar", { fg = "#a6c8ff"})
            vim.api.nvim_set_hl(0, "TelescopeMatching", { fg = "#e8daff" })
          '';
          type = "lua";
          optional = false;
        }
      ];
    };

    xdg.configFile."nvim/plugin/statusline.lua".source = ./galaxy-line-dev-null.lua;

    xdg.configFile."tmux/statusline.tmux".source = ./dev-null.tmux;
    programs.starship.settings = {
      format = ''
        [](fg:#202020 bg:#141414)$jobs$directory[](fg:#202020 bg:#141414)$fill[$git_branch$git_status ](bg:#202020)[](fg:#202020 bg:#141414)
        [  ├─](fg:#484848) $username$hostname$kubernetes$elixir
        [  └──](fg:#484848) $character 
      '';
      character = {
        format = "$symbol";
        error_symbol = "[ ](bold #FF75B6)";
        success_symbol = "[ ](bold #C6C6C6)";
        vimcmd_symbol = "[ ](bold #9ef0f0)";
      };

      username = {
        show_always = true;
        format = "[$user](fg:#C6C6C6)";
      };

      fill = {
        symbol = "";
        style = "fg:#141414 bg:#141414";
      };

      elixir = {
        symbol = " ";
        format = "[$symbol](fg:#d4bbff)[$version \\($otp_version\\)](fg:#C6C6C6)";
      };

      directory = {
        format = "[   $path ](bg:#202020 fg:#C6C6C6)";
        truncation_length = 5;
        truncate_to_repo = false;
      };

      kubernetes = {
        disabled = false;
        symbol = "󱃾 ";
        format = "[ $symbol](fg:#82AAFF)[$context/$namespace ](fg:#C6C6C6)";
      };

      git_branch = {
        format = "[](fg:#202020 bg:#141414)[  $branch ](bg:#202020 fg:#C6C6C6)";
      };

      git_status = {
        format = "$ahead_behind$stashed$staged$modified$deleted$untracked";
        style = "#C6C6C6";
        ahead = "[ ](bg:#202020 bold #d5ff5e)";
        behind = "[ ](bg:#202020 bold #d5ff5e)";
        up_to_date = "[- ](bg:#202020 bold #C6C6C6)";
        diverged = "[](bg:#202020 bold #d5ff5e)";
        staged = "[](bg:#202020 #9ef0f0)";
        untracked = "[](bg:#202020 #C6C6C6)";
        modified = "[](bg:#202020 #d4bbff)";
        stashed = "[](bg:#202020 #d5ff5e)";
        deleted = "[](bg:#202020 #FF75B6)";
      };

      jobs = {
        symbol = " 󰠜 ";
        style = "#C6C6C6";
      };

      status = {
        format = "[ $symbol$status ](fg:#C6C6C6 bg:#222222)";
        disabled = false;
        symbol = " ";
      };

      hostname = {
        ssh_only = false;
        format = "[@$hostname](italic fg:#C6C6C6)";
      };
    };

    programs.opencode = {
      tui.theme = "dev-null";
      themes.dev-null = {
        defs = {
          # bg = "#161616";
          bg = "#141414";
          surface = "#1B1B1B";
          surfaceAlt = "#252525";
          border = "#393939";
          borderActive = "#484848";
          fg = "#c6c6c6";
          muted = "#6f6f6f";
          # primary = "#3ddbd9";
          primary = "#9ef0f0";
          accent = "#a56eff";
          listing = "#d0e2ff";
          heading = "#d4bbff";
          link = "#78a9ff";
          interactive = "#be95ff";
          success = "#3ddbd9";
          warning = "#d5ff5e";
          error = "#ee5396";
          info = "#78a9ff";
          diffAdd = "#08bdba";
          diffAddBg = "#173634";
          diffDelete = "#ee5396";
          diffDeleteBg = "#2b1828";
          string = "#d9fbfb";
          variable = "#f4f4f4";
          property = "#a6c8ff";
          constant = "#78a9ff";
          operator = "#d0e2ff";
          object = "#a6c8ff";
        };
        theme = {
          primary = {
            dark = "primary";
          };
          secondary = {
            dark = "accent";
          };
          accent = {
            dark = "accent";
          };
          error = {
            dark = "error";
          };
          warning = {
            dark = "warning";
          };
          success = {
            dark = "success";
          };
          info = {
            dark = "info";
          };
          text = {
            dark = "fg";
          };
          textMuted = {
            dark = "muted";
          };
          background = {
            dark = "bg";
          };
          # backgroundPanel = { dark = "surface"; };
          # backgroundElement = { dark = "surfaceAlt"; };
          backgroundPanel = {
            dark = "surface";
          };
          backgroundElement = {
            dark = "surface";
          };
          border = {
            dark = "border";
          };
          borderActive = {
            dark = "borderActive";
          };
          borderSubtle = {
            dark = "border";
          };
          diffAdded = {
            dark = "success";
          };
          diffRemoved = {
            dark = "error";
          };
          diffContext = {
            dark = "surfaceAlt";
          };
          diffHunkHeader = {
            dark = "surfaceAlt";
          };
          diffHighlightAdded = {
            dark = "diffAdd";
          };
          diffHighlightRemoved = {
            dark = "diffDelete";
          };
          diffAddedBg = {
            dark = "diffAddBg";
          };
          diffRemovedBg = {
            dark = "diffDeleteBg";
          };
          diffContextBg = {
            dark = "surface";
          };
          diffLineNumber = {
            dark = "muted";
          };
          diffAddedLineNumberBg = {
            dark = "diffAddBg";
          };
          diffRemovedLineNumberBg = {
            dark = "diffDeleteBg";
          };
          markdownText = {
            dark = "fg";
          };
          markdownHeading = {
            dark = "heading";
          };
          markdownLink = {
            dark = "link";
          };
          markdownLinkText = {
            dark = "accent";
          };
          markdownCode = {
            dark = "string";
          };
          markdownBlockQuote = {
            dark = "muted";
          };
          markdownEmph = {
            dark = "accent";
          };
          markdownStrong = {
            dark = "heading";
          };
          markdownHorizontalRule = {
            dark = "muted";
          };
          markdownListItem = {
            dark = "fg";
          };
          markdownListEnumeration = {
            dark = "listing";
          };
          markdownImage = {
            dark = "listing";
          };
          markdownImageText = {
            dark = "link";
          };
          markdownCodeBlock = {
            dark = "fg";
          };
          syntaxComment = {
            dark = "muted";
          };
          syntaxKeyword = {
            dark = "accent";
          };
          syntaxFunction = {
            dark = "interactive";
          };
          syntaxVariable = {
            dark = "variable";
          };
          syntaxString = {
            dark = "string";
          };
          syntaxNumber = {
            dark = "constant";
          };
          syntaxType = {
            dark = "interactive";
          };
          syntaxOperator = {
            dark = "operator";
          };
          syntaxPunctuation = {
            dark = "operator";
          };
        };
      };
    };
  };
}
