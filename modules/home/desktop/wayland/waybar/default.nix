{ config, lib, pkgs, ... }:

with lib;
let
  cfg = config.delta.desktop.wayland.waybar;
in
{
  options.delta.desktop.wayland.waybar = with types; {
    enable = mkEnableOption "waybar";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.noto-fonts pkgs.playerctl ];

    services.playerctld.enable = true;

    programs.waybar = {
      enable = true;
      systemd.enable = true;
      package = pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ]; });
      settings = {
        mainBar = {
          start_hidden = false;
          margin = "0";
          layer = "top";
          modules-left = [ "hyprland/workspaces" "mpris" ];
          modules-center = [ "wlr/taskbar" ];
          modules-right = [ "network#interface" "network#speed" "cpu" "temperature" "backlight" "battery" "clock" "custom/notification" "tray" ];

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

          "custom/notification" = {
            exec = "~/.config/waybar/scripts/dunst.sh";
            tooltip = false;
            on-click = "dunstctl set-paused toggle";
            restart-interval = 1;
          };

          tray = {
            icon-size = 16;
            spacing = 8;
          };
        };
      };

      style = ''
        * {
          min-height: 0;
        }

        window#waybar {
          font-family: 'Noto', 'RobotoMono Nerd Font';
          font-size: 10px;
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

        #custom-notification {
          padding: 0 4px 0 4px;
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

    xdg.configFile."waybar/scripts/dunst.sh" = {
      text = ''
        COUNT=$(dunstctl count waiting)
        ENABLED="󰂚 "
        DISABLED="󰂛 "
        if [ $COUNT != 0 ]; then DISABLED="󱅫 "; fi
        if dunstctl is-paused | grep -q "false"; then
          echo $ENABLED
        else
          echo $DISABLED
        fi
      '';
      executable = true;
    };

    xdg.configFile."waybar/scripts/task-context.sh" = {
      text = ''
        ICON=" "
        CONTEXT=$(task _get rc.context)

        if [ -z "$CONTEXT" ]; then
          CONTEXT="NONE"
        fi
        echo "$ICON $CONTEXT"
      '';
      executable = true;
    };
  };
}
