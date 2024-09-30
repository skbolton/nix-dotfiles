{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.delta.desktop.dunst;
in
{
  options.delta.desktop.dunst = with types; {
    enable = mkEnableOption "dunst";
  };


  config = mkIf cfg.enable {
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
          follow = "mouse";
        };

        urgency_low = {
          background = "#2D2B40";
        };

        urgency_normal = {
          background = "#2D2B40";
          script = "/home/orlando/.config/dunst/play_normal.sh";
        };

        urgency_critical = {
          background = "#2D2B40";
          foreground = "#CBE3E7";
          frame_color = "#F48FB1";
          script = "/home/orlando/.config/dunst/play_critical.sh";
        };

        discord = {
          appname = "Discord";
          urgency = "low";
        };
      };
    };

    xdg.configFile."dunst/play_critical.sh" = {
      executable = true;
      text = "${pkgs.mpv}/bin/mpv ${pkgs.kdePackages.ocean-sound-theme}/share/sounds/ocean/stereo/dialog-question.oga";
    };

    xdg.configFile."dunst/play_normal.sh" = {
      executable = true;
      text = "${pkgs.mpv}/bin/mpv ${pkgs.kdePackages.ocean-sound-theme}/share/sounds/ocean/stereo/desktop-login.oga";
    };
  };
}
