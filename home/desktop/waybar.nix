{ pkgs, ... }:

{

  services.playerctld.enable = true;

  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true"] ;} );
    settings = {
      mainBar = {
        margin = "0";
        modules-left = [ "wlr/workspaces" "mpris" ];
        modules-center = [ "wlr/taskbar"];
        modules-right = [ "pulseaudio" "network#interface" "network#speed" "cpu" "temperature" "clock" ];

        persistent_workspaces = {
          "1" = [];
          "2" = [];
          "3" = [];
        };

        "wlr/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          format-icons = {
            "1" = "";
            "2" = "󰈹";
            "3" = "󰒱";
            "4" = "󰧑";
          };
        };

        mpris = {
          format = "{status_icon} {artist} / {title}";
          status-icons = {
            playing = "󰎈";
            paused = "󰏤";
            stopped = "󰓛";
          };
        };

        "wlr/taskbar" = {
          on-click = "activate";
        };

        pulseaudio = {
          format = "󰓃 {volume}%";
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
          format = "  {usage}% 󱐌{avg_frequency}";
        };

        temperature = {
          format = "{icon} {temperatureC} °C";
          format-icons = [ "" "" "" "󰈸"];
        };

        clock = {
          format = "󰥔 {:%H:%M}";
          format-alt = "󰃭 {:%Y-%m-%d}";
        };
      };
    };

    style = ''
      window#waybar {
        border-bottom: solid 2px #2D2B40;
        font-family: RobotoMono Nerd Font;
        font-size: 14px;
      }

      tooltip {
        background-color: #100E23;
        color: #CBE3E7;
      }

      #workspaces button {
        padding: 8px;
        margin-right: 8px;
      }

      #workspaces button.active {
        color: #d4bfff;
      }

      .modules-right * {
        padding: 0 8px;
        margin-left: 8px;
      }

      #mpris {
        background-color: #2D2B40;
        padding: 0 8px;
        color: #8A889D;
      }

      #pulseaudio {
        background-color: #F48FB1;
        color: #100E23;
      }

      #network.interface {
        background-color: #91DDFF;
        color: #100E23;
      }

      #network.speed {
        background-color: #78A8FF;
        color: #100E23;
      }


      #cpu {
        background-color: #D4BFFF;
        color: #100E23;
      }

      #temperature {
        background-color: #FFE6B3;
        color: #100E23;
      }


      #clock {
        background-color: #A1EFD3;
        color: #100E23;
      }
    '';
  };
}

