{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.kitty;
in
{
  options.delta.kitty = with types; {
    enable = mkEnableOption "Elixir Language support";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nerd-fonts.roboto-mono
      ibm-plex
      lilex
      courier-prime
      roboto-mono
      recursive
    ];

    programs.kitty = {
      enable = true;

      settings = {
        # UI and Window Behavior
        window_padding_width = "0 8";
        remember_window_size = "no";
        hide_window_decorations = if pkgs.stdenv.isLinux then "yes" else "titlebar-only";
        dynamic_background_opacity = "yes";
        background_opacity = 1;
        cursor_shape = "beam";
        cursor_trail = 1;
        cursor_trail_decay = "0.1 0.3";
        cursor_trail_start_threshold = 5;

        font_family = "Lilex";
        bold_font = "Operator Mono Bold";
        bold_italic_font = "Rec Mono Bold Italic";
        italic_font = "Rec Mono Casual Italic";
        font_size = "14.0";

        # Terminal Settings
        allow_remote_control = "yes";
        listen_on = if pkgs.stdenv.isLinux then "unix:@mykitty" else "tcp:localhost:12345";
        confirm_os_window_close = 0;
        copy_on_select = "clipboard";
        clipboard_control = "write-clipboard write-primary no-append";
        sync_to_monitor = "no";
        macos_titlebar_color = "background";
        macos_show_window_title_in = "none";
        macos_option_as_alt = true;
      };

      environment = {
        THEME = "embark";
        TMUX_STATUSLINE = "neoline-embark";
        NVIM_STATUSLINE = "neoline";
      };

      keybindings = {
        "ctrl+alt+l" = "set_background_opacity +0.05";
        "ctrl+alt+h" = "set_background_opacity -0.05";
        "ctrl+alt+enter" = "set_background_opacity default";
        "ctrl+alt+k" = "change_font_size current +2.0";
        "ctrl+alt+j" = "change_font_size current -2.0";
        "ctrl+alt+z" = "change_font_size current 18.0";
        "ctrl+alt+u" = "change_font_size all 0";
        "ctrl+alt+backspace" = "change_font_size all 0";
        "ctrl+alt+period" = "send_text current pass fzf\r";
        "ctrl+alt+p" = "send_text all ${pkgs.delta.rally}/bin/rally.sh\\r";
        "ctrl+alt+t" = "send_text all rebuild\\r";
        "ctrl+alt+r" = "send_text all zk runbooks\r";
        "ctrl+alt+c" = "send_text all zk cast\u0020";
      };

      extraConfig = ''
        modify_font cell_height 120%
        # not needed with maple, keeping around for other fonts
        # Seti
        symbol_map U+E5FA-U+E6B1 RobotoMono Nerd Font
        # Devicons
        symbol_map U+E700-U+E7C5 RobotoMono Nerd Font
        # Font Awesome
        symbol_map U+F000-U+F2E0 RobotoMono Nerd Font
        # Font Awesome Extension
        symbol_map U+E200-U+E2A9 RobotoMono Nerd Font
        # Material Design
        symbol_map U+F0001-U+F1AF0 RobotoMono Nerd Font
        # Weather
        symbol_map U+E300-U+E3E3 RobotoMono Nerd Font
        # Octicons
        symbol_map U+F400-U+F532,U+2665-U+26A1 RobotoMono Nerd Font
        # Powerline
        symbol_map U+E0A0-U+E0A2,U+E0B0-U+E0B3 RobotoMono Nerd Font
        # Powerline Extras
        symbol_map U+E0A3,U+E0B4-U+E0C8,U+E0CA-U+E0D4 RobotoMono Nerd Font
        # IEC Power
        symbol_map U+23FB-U+23FE,U+2B58 RobotoMono Nerd Font
        # Font Logos
        symbol_map U+F300-U+F372 RobotoMono Nerd Font
        # Pomicons
        symbol_map U+E000-U+E00A RobotoMono Nerd Font
        # Codeicons
        symbol_map U+EA60-U+EBEB RobotoMono Nerd Font
      '';

    };

    xdg.configFile."kitty/themes" = {
      source = ./themes;
      recursive = true;
    };

    xdg.configFile."kitty/kitty-light.conf".text = ''
      include ./kitty.conf
      include ./themes/inspired-github.conf
      font_family Maple Mono Light
      bold_font Maple Mono Bold
      bold_italic_font Maple Mono Bold Italic
      italic_font Maple Mono Light Italic
      font_size 14.0
    '';
  };
}
