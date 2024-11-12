{ pkgs, ... }:

{
  home.packages = with pkgs; [
    delta.io-collins
    (nerdfonts.override { fonts = [ "RobotoMono" "Iosevka" ]; })
    ibm-plex
    iosevka
  ];

  programs.kitty = {
    enable = true;

    settings = {
      # UI and Window Behavior
      window_padding_width = "0 8";
      remember_window_size = "no";
      hide_window_decorations = if pkgs.stdenv.isLinux then "yes" else "no";
      dynamic_background_opacity = "yes";
      background_opacity = 1;
      cursor_shape = "beam";

      font_family = "IOCollins Light";
      bold_font = "Berkeley Mono Bold";
      bold_italic_font = "Berkeley Mono Bold Italic";
      italic_font = "IOCollins Italic";
      font_size = "13.0";

      # Terminal Settings
      allow_remote_control = "yes";
      listen_on = if pkgs.stdenv.isLinux then "unix:@mykitty" else "unix:$${TMPDIR}/mykitty";
      confirm_os_window_close = 0;
      copy_on_select = "clipboard";
      clipboard_control = "write-clipboard write-primary no-append";
      sync_to_monitor = "no";
      macos_titlebar_color = "background";
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
      "ctrl+alt+t" = "send_text all sudo nixos-rebuild switch\\r";
      "ctrl+alt+r" = "send_text all zk runbooks\r";
      "ctrl+alt+c" = "send_text all zk cast\u0020";
    };

    extraConfig = ''
      modify_font cell_height 120%
      include ./themes/theme.conf
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
    font_family IOCollins Semibold
    bold_font Berkeley Mono Bold
    bold_italic_font Berkeley Mono Bold Italic
    italic_font IOCollins Italic
    font_size 13.0
  '';

  xdg.dataFile."fonts/Lilex" = {
    source = ./Lilex;
    recursive = true;
  };

  xdg.dataFile."fonts/OneMono" = {
    source = ./OneMono;
    recursive = true;
  };

  xdg.dataFile."fonts/OxProto" = {
    recursive = true;
    source = (pkgs.fetchzip {
      url = "https://github.com/0xType/0xProto/archive/refs/tags/2.001.zip";
      sha256 = "sha256-MeblKXwxlVoHlx61W8YdLEXaeWE6TIXK3KmIiDZhdxQ=";
    }) + "/fonts";
  };
}
