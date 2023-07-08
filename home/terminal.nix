{ pkgs, ... }:
{

  home.packages = with pkgs; [
    iosevka
  ];

  programs.kitty = {
    enable = true;

    settings = {
      # UI and Window Behavior
      window_padding_width = "4 8";
      remember_window_size = "no";
      hide_window_decorations = "yes";
      dynamic_background_opacity = "yes";
      background_opacity = 1;
      cursor_shape = "beam";

      font_family = "Iosevka";
      italic_font = "Operator Mono Book Italic";
      bold_italic_font = "Operator Mono Bold Italic";
      font_size = "12.0";

      # Terminal Settings
      allow_remote_control = "yes";
      listen_on = "unix:@mykitty";
      confirm_os_window_close = 0;
      copy_on_select = "clipboard";
      clipboard_control = "write-clipboard write-primary no-append";
      enable_audio_bell = "no";
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
      "ctrl+alt+z" = "change_font_size current 22.0";
      "ctrl+alt+u" = "change_font_size current 12.0";
      "ctrl+alt+backspace" = "change_font_size all 0";
      "ctrl+alt+period" =  "send_text current pass fzf\r";
      "ctrl+alt+p" = "send_text all ~/.config/tmux/scripts/rally.sh\\r";
      "ctrl+alt+t" = "send_text all titan-call\r";
      "ctrl+alt+r" = "send_text all zk runbooks\r";
      "ctrl+alt+c" = "send_text all zk cast\u0020";
    };

    extraConfig = ''
    include ./themes/embark.conf
    # Seti
    symbol_map U+E5FA-U+E631 RobotoMono Nerd Font
    # Devicons
    symbol_map U+E700-U+E7C5 RobotoMono Nerd Font
    # Font Awesome
    symbol_map U+F000-U+F2E0 RobotoMono Nerd Font
    # Font Awesome Extension
    symbol_map U+E200-U+E2A9 RobotoMono Nerd Font
    # Material Design
    symbol_map U+F500-U+FD46 RobotoMono Nerd Font
    # Weather
    symbol_map U+E300-U+E3EB RobotoMono Nerd Font
    # Octicons
    symbol_map U+F400-U+F4A9,U+2665-U+26A1 RobotoMono Nerd Font
    # Powerline
    symbol_map U+E0A0-U+E0A2,U+E0B0-U+E0B3 RobotoMono Nerd Font
    # Powerline Extras
    symbol_map U+E0A3,U+E0B4-U+E0C8,U+E0CC-U+E0D4 RobotoMono Nerd Font
    # IEC Power
    symbol_map U+23FB-U+23FE,U+2B58 RobotoMono Nerd Font
    # Font Logos
    symbol_map U+F300-U+F32D RobotoMono Nerd Font
    # Pomicons
    symbol_map U+E000-U+E00A RobotoMono Nerd Font
    # Codeicons
    symbol_map U+EA60-U+EBEB RobotoMono Nerd Font

    symbol_map U+EA76 VictorMono Nerd Font
    '';

  };

  xdg.configFile."kitty/themes/embark.conf" = {
    text = ''
      background #1E1C31
      foreground #CBE3E7

      cursor #A1EFD3

      selection_background  #3E3859
      selection_foreground #CBE3E7

      # black
      color0 #1E1C31
      color8  #585273

      # red
      color1 #F48FB1
      color9 #F02E6E

      # green
      color2 #A1EFD3
      color10 #7FE9C3

      # yellow
      color3       #FFE6B3
      color11      #F2B482

      # blue
      color4 #91DDFF
      color12 #78A8FF

      # magenta
      color5 #D4BFFF
      color13 #7676FF

      # cyan
      color6       #ABF8F7
      color14      #63F2F1

      # white
      color7 #CBE3E7
      color15 #8A889D

      active_border_color #A1EFD3
      inactive_border_color #585273
      bell_border_color #F56574

      active_tab_foreground   #2D2B40
      active_tab_background   #63F2F1
      active_tab_font_style   bold

      inactive_tab_foreground #CBE3E7
      inactive_tab_background #585273
      inactive_tab_font_style normal

      url_color #D4BFFF
    '';
  };
}
