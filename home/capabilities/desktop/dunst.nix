{ pkgs, ... }:

{
  home.packages = with pkgs; [ inter mpv ];

  services.dunst = {
    enable = true;
    iconTheme = {
      name = "Fluent-dark";
      package = pkgs.fluent-icon-theme;
    };
    settings = {
      global = {
        font = "Inter 12";
        frame_color = "#100E23";
        frame_width = "2";
        origin = "top-right";
        offset = "8x4";
        width = "300";
        height = "200";
        padding = 16;
        horizontal_padding = 16;
        separator_color = "#585273";
      };

      urgency_low = {
        background = "#2D2B40";
      };

      urgency_normal = {
        background = "#2D2B40";
      };

      urgency_critical = {
        foreground = "#2D2B40";
        background = "#D4BFFF";
      };

      discord = {
        appname = "Discord";
        urgency = "low";
      };

      beep = {
        summary = "Remind*";
        urgency = "critical";
        script = "/home/orlando/.config/dunst/play_beep.sh";
      };
    };
  };

  xdg.configFile."dunst/play_beep.sh" = {
    executable = true;
    text = "${pkgs.mpv}/bin/mpv ~/.config/dunst/beep.mp3";
  };

  xdg.configFile."dunst/beep.mp3".source = ./beep.mp3;
}
