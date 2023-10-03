{ pkgs, ...}:

let
  rally = import ../tmux/rally.nix { inherit pkgs; };
in
{
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

      font_family = "Lilex";
      # Yep they spelled medium wrong
      bold_font = "Lilex Meduim";
      italic_font = "Lilex Italic";
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
      TMUX_STATUSLINE = "cleanline";
      NVIM_STATUSLINE = "rocket-line";
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
      "ctrl+alt+p" = "send_text all ${rally}/bin/rally.sh\\r";
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

  xdg.configFile."kitty/themes" = {
    source = ./themes;
    recursive = true;
  };

  xdg.configFile."kitty/kitty-light.conf".text = ''
  include ./kitty.conf
  env THEME=tantric
  env TMUX_STATUSLINE=cleanline
  env NVIM_STATUSLINE=rocket-line
  include ./themes/tantric.conf
  '';

  xdg.dataFile."fonts/IBMPlexMono.ttf".source = ./IBMPlexMono.ttf;

  xdg.dataFile."fonts/Lilex" = {
    source = ./Lilex;
    recursive = true;
  };
}
