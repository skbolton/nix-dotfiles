{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.delta.desktop.wayland.waybar;
in
{
  options.delta.desktop.wayland.waybar = with types; {
    enable = mkEnableOption "waybar";
    target = mkOption {
      type = str;
      default = "graphical-session.target";
    };
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.noto-fonts pkgs.playerctl ];

    services.playerctld.enable = true;

    programs.waybar = {
      enable = true;
      systemd.enable = true;
      systemd.target = cfg.target;
      settings = {
        mainBar = {
          start_hidden = false;
          margin = "0";
          layer = "top";
          modules-left = optional config.delta.desktop.wayland.hyprland.enable "hyprland/workspaces" ++ optionals config.delta.desktop.wayland.river.enable [ "river/tags" "river/mode" ];
          modules-center = [ "mpris" ];
          modules-right = [ "network#interface" "network#speed" "pulseaudio" "cpu" "temperature" "backlight" "battery" "clock" "tray" ];

          persistent_workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
          };

          "hyprland/workspaces" = {
            format = "{icon}";
            on-click = "activate";
            sort-by-number = true;
            format-icons = {
              "default" = "";
              "active" = "";
            };
          };

          "river/tags" = {
            num-tags = 5;
            tag-labels = [ " " "󰈹 " "󰙯 " "󰝚 " ];
          };

          mpris = {
            format = "{status_icon}<span weight='bold'>{artist}</span> | {title}";
            status-icons = {
              playing = "󰎈 ";
              paused = "󰏤 ";
              stopped = "󰓛 ";
            };
          };

          "wlr/taskbar" = {
            on-click = "activate";
            icon-theme = "Fluent-dark";
          };

          "network#interface" = {
            format-ethernet = "󰣶 {ifname}";
            format-wifi = "󰖩 {ifname}";
            tooltip = true;
            tooltip-format = "{ipaddr}";
          };

          "network#speed" = {
            format = "⇡{bandwidthUpBits} ⇣{bandwidthDownBits}";
          };

          pulseaudio = {
            format = "󰓃 {volume}%";
            on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
          };

          cpu = {
            format = " {usage}% 󱐌{avg_frequency}";
          };

          temperature = {
            format = "{icon} {temperatureC} °C";
            format-icons = [ "" "" "" "󰈸" ];
          };

          backlight = {
            format = "{icon} {percent}%";
            format-icons = [ "󰃜" "󰃛" "󰃚 " ];
          };

          battery = {
            format-critical = "{icon} {capacity}%";
            format = "{icon} {capacity}%";
            format-icons = [ "󰁺" "󰁾" "󰂀" "󱟢" ];
          };

          clock = {
            format = " {:%H:%M}";
            format-alt = "󰃭 {:%Y-%m-%d}";
          };

          tray = {
            icon-size = 16;
            spacing = 8;
          };
        };
      };

      style = /* css */ ''
        * {
          min-height: 0;
        }

        window#waybar {
          font-family: 'Noto', 'RobotoMono Nerd Font';
          font-size: 12px;
          background: transparent;
        }

        #tags button {
          padding: 0px 4px;
        }

        #tags button.focused {
          color: #A1EFD3;
        }

        tooltip {
          background: @unfocused_borders;
        }

        #custom-nix {
          padding: 0px 4px;
        }

        #workspaces button {
          padding: 0px 4px;
          margin: 0 4px 0 0;
        }

        .modules-right * {
          padding: 0 4px;
          margin: 0 0 0 4px;
        }

        #mpris {
          padding: 0 4px;
        }

        #tray {
          padding: 0 4px;
        }
      
        #tray * {
          padding: 0;
          margin: 0;
        }
      '';
    };
  };
}
