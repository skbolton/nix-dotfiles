{
  inputs,
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.delta.evergloom-theme;
in
{
  options.delta.evergloom-theme = {
    enable = lib.mkEnableOption "evergloom theme";
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
      enable = true;
      package = pkgs.fluent-icon-theme;
      dark = "Fluent-dark";
      light = "Fluent";
    };

    stylix.targets.neovim.enable = false;
    stylix.targets.bat.enable = false;
    stylix.targets.btop.enable = false;
    stylix.targets.fzf.enable = false;
    stylix.targets.tmux.enable = false;
    stylix.targets.starship.enable = false;
    # need to make a custom theme as the stylix form misses on some marks
    # will just rock system in the meantime
    stylix.targets.opencode.enable = false;

    programs.kitty.extraConfig = ''
      include ${./kitty-evergloom.conf}
    '';

    programs.kitty.settings = {
      bold_font = lib.mkForce "Berkeley Mono Bold";
      font_family = lib.mkForce "Berkeley Mono";
      bold_italic_font = lib.mkForce "Berkeley Mono Bold Italic";
      italic_font = lib.mkForce "Rec Mono Casual Italic";
    };

    programs.neovim = {
      plugins = [
        {
          plugin = pkgs.vimUtils.buildVimPlugin {
            name = "embark-vim";
            src = inputs.evergloom-nvim;
          };
          optional = false;
          config = /* lua */ ''
            require 'evergloom'.setup {}

            vim.cmd("colorscheme evergloom")
            vim.api.nvim_set_hl(0, "TelescopeSelection", {bg = "#0b253a"})
            vim.api.nvim_set_hl(0, "TelescopeMatching", {fg = "#6ae9f0"})
            vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", {fg = "#6ae9f0", bg = "#0b253a"})
            vim.api.nvim_set_hl(0, "TelescopeBorder", {fg = "#0b253a"})
            vim.api.nvim_set_hl(0, "@text.reference", { link = "Function" })
          '';
          type = "lua";
        }
      ];
    };

    xdg.configFile."nvim/plugin/statusline.lua".source = ./galaxy-line-evergloom.lua;

    xdg.configFile."tmux/statusline.tmux".source = ./evergloom.tmux;

    programs.starship.settings = {
      format = ''
        [](fg:#122d42 bg:#011627)$jobs$directory[](fg:#122d42 bg:#011627)$fill[$git_branch$git_status ](bg:#122d42)[](fg:#122d42 bg:#011627)
        [  ├─](fg:#5f7e97) $username$hostname$kubernetes$elixir
        [  └──](fg:#5f7e97) $character 
      '';
      character = {
        format = "$symbol";
        error_symbol = "[ ](bold #ef5075)";
        success_symbol = "[ ](bold #80A4C2)";
        vimcmd_symbol = "[ ](bold #3CD6A8)";
      };

      username = {
        show_always = true;
        format = "[$user](fg:#80A4C2)";
      };

      fill = {
        symbol = "";
        style = "fg:#011627 bg:#011627";
      };

      elixir = {
        symbol = " ";
        format = "[$symbol](fg:#c792ea)[$version \\($otp_version\\)](fg:#80A4C2)";
      };

      directory = {
        format = "[   $path ](bg:#122d42 fg:#80A4C2)";
        truncation_length = 5;
        truncate_to_repo = false;
      };

      kubernetes = {
        disabled = false;
        symbol = "󱃾 ";
        format = "[ $symbol](fg:#82AAFF)[$context/$namespace ](fg:#80A4C2)";
      };

      git_branch = {
        format = "[](fg:#122d42 bg:#011627)[  $branch ](bg:#122d42 fg:#80A4C2)";
      };

      git_status = {
        format = "$ahead_behind$stashed$staged$modified$deleted$untracked";
        style = "#80A4C2";
        ahead = "[ ](bg:#122d42 bold #c5e478)";
        behind = "[ ](bg:#122d42 bold #c5e478)";
        up_to_date = "[- ](bg:#122d42 bold #80A4C2)";
        diverged = "[](bg:#122d42 bold #c5e478)";
        staged = "[](bg:#122d42 #3CD6A8)";
        untracked = "[](bg:#122d42 #80A4C2)";
        modified = "[](bg:#122d42 #c792ea)";
        stashed = "[](bg:#122d42 #ffeb95)";
        deleted = "[](bg:#122d42 #ef5075)";
      };

      jobs = {
        symbol = " 󰠜 ";
        style = "#80A4C2";
      };

      status = {
        format = "[ $symbol$status ](fg:#80A4C2 bg:#122d42)";
        disabled = false;
        symbol = " ";
      };

      hostname = {
        ssh_only = false;
        format = "[@$hostname](italic fg:#80A4C2)";
      };
    };

    programs.bat = {
      config.theme = "evergloom";
      themes.evergloom = {
        src = ./evergloom.tmTheme;
      };
    };

    programs.delta.options."syntax-theme" = "evergloom";

    wayland.windowManager.mango.settings.root_color = "0x011627FF";
    wayland.windowManager.mango.settings.border_px = 2;
    wayland.windowManager.mango.settings.border_color = "0x11627FF";
    wayland.windowManager.mango.settings.focus_color = "0x122d42FF";

    programs.fzf.colors = {
      "bg+" = "#011627";
      "gutter" = "#011627";
      "fg" = "#8b9bb4";
      "fg+" = "#8b9bb4";
      "prompt" = "#7FDBCA";
      "header" = "#82AAFF";
      "pointer" = "#6ae9f0";
      "current-bg" = "#0b253a";
      "hl" = "#6ae9f0";
      "hl+" = "#6ae9f0";
      "spinner" = "#f78c6c";
      "info" = "#82AAFF";
      "border" = "#1E3A5F";
    };

    programs.btop.settings.color_theme = "night-owl";
  };
}

# local colors = {
# 	fg = "#d6deeb",
# 	bg = "#021727",
# 	folded_bg = "#092135",
# 	cursor_fg = "#805a3e",
# 	cursor_bg = "#80a4c2",
# 	line_number_fg = "#4b6479",
# 	line_number_active_fg = "#c5e4fc",
# 	sign_add = "#9ccc65",
# 	sign_change = "#e2b93d",
# 	sign_delete = "#ef5350",
# 	indent_guide = "#1f395d",
# 	indent_guide_active = "#7e97ac",
# 	visual = "#1d3b53",
# 	match_paren = "#1e364a",
# 	search_blue = "#063e5d",
# 	incremental_search_blue = "#2E485C",
# 	error_red = "#ef5350",
# 	word_highlight = "#33384d",
# 	word_highlight_write = "#2f3350",
# 	changed = "#a2bffc",
# 	quickfix_line = "#0e293f",
# 	ui_border = "#5f7e97",
# 	ui_border2 = "#20395d",
# 	nvim_tree_file = "#89a4bb",
# 	nvim_tree_indent_marker = "#585858",
# 	tab_active_bg = "#0b2942",
# 	tab_inactive_bg = "#01111d",
# 	title = "#82b1ff",
# 	parameter = "#d7dbe0",
# 	string_delimiter = "#d9f5dd",
# 	dark = "#010d18",
# 	dark2 = "#021320",
# 	dark3 = "#99b76d23",
# 	white = "#ffffff",
# 	white2 = "#eeefff",
# 	dark_white = "#cccccc",
# 	gray = "#262a39",
# 	gray2 = "#d2dee7",
# 	gray3 = "#36414a",
# 	gray4 = "#d6deeb80",
# 	gray5 = "#969696",
# 	gray6 = "#7e97ac",
# 	light_blue = "#78ccf0",
# 	blue = "#82aaff",
# 	blue2 = "#0b253a",
# 	blue3 = "#122d42",
# 	blue4 = "#1b90dd4d",
# 	blue5 = "#234d70",
# 	blue6 = "#234d708c",
# 	blue7 = "#395a75",
# 	blue8 = "#5ca7e4",
# 	blue9 = "#5f7e9779",
# 	blue10 = "#697098",
# 	blue11 = "#8eace3",
# 	blue12 = "#b2ccd6",
# 	blue13 = "#072232",
# 	blue14 = "#273845",
# 	blue15 = "#169fff",
# 	green = "#c5e478",
# 	green2 = "#6CC85E",
# 	light_cyan = "#caece6",
# 	cyan = "#6ae9f0",
# 	cyan2 = "#7fdbca",
# 	cyan3 = "#7fdbcaff",
# 	cyan4 = "#80cbc4",
# 	cyan5 = "#baebe2",
# 	dark_cyan = "#637777",
# 	light_red = "#ff869a",
# 	red = "#ff5874",
# 	red2 = "#ff6363",
# 	red3 = "#ef535090",
# 	-- dark_red = "#ab0300f2",
# 	dark_red = "#ab0300",
# 	light_orange = "#ecc48d",
# 	orange = "#f78c6c",
# 	orange2 = "#ffcb8b",
# 	light_yellow = "#faf39f",
# 	yellow = "#ffd602",
# 	yellow2 = "#b39554",
# 	yellow3 = "#fad430",
# 	yellow4 = "#ffeb95",
# 	yellow5 = "#ffeb95cc",
# 	light_purple = "#a599e9",
# 	purple = "#7e57c2",
# 	purple2 = "#5166F0",
# 	purple3 = "#da70d6",
# 	purple4 = "#7986e7",
# 	dark_purple = "#2E2D5E",
# 	magenta = "#c792ea",
# 	magenta2 = "#c789d6",
# 	magenta3 = "#d1aaff",
# 	magenta4 = "#ff2c83",
# 	magenta5 = "#e2a2f433",
# 	magenta6 = "#f6bbe533",
# }
#
# return colors
