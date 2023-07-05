{ pkgs, ... }:

{

  home.packages = [ pkgs.inter ];

  services.playerctld.enable = true;

  programs.waybar = {
    enable = true;
    package = pkgs.waybar.overrideAttrs (oldAttrs: { mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true"] ;} );
    settings = {
      mainBar = {
        margin = "0";
        layer = "top";
        modules-left = [ "wlr/workspaces" "mpris" ];
        modules-center = [ "wlr/taskbar"];
        modules-right = [ "pulseaudio" "network#interface" "network#speed" "cpu" "temperature" "clock" "tray" ];

        persistent_workspaces = {
          "1" = [];
          "2" = [];
          "3" = [];
        };

        "wlr/workspaces" = {
          format = "{icon}";
          on-click = "activate";
          sort-by-number = true;
          format-icons = {
            "1" = "<span foreground=\"#A1EFD3\"></span>";
            "2" = "<span foreground=\"#FFE6B3\">󰈹</span>";
            "3" = "<span foreground=\"#91DDFF\">󰒱</span>";
            "4" = "<span foreground=\"#D4BFFF\">󰧑</span>";
          };
        };

        mpris = {
          format = "{status_icon} {artist} / {title}";
          status-icons = {
            playing = "󰎈 ";
            paused = "󰏤 ";
            stopped = "󰓛 ";
          };
        };

        "wlr/taskbar" = {
          on-click = "activate";
        };

        pulseaudio = {
          format = "󰓃 {volume}%";
        };

        "network#interface" = {
          format-ethernet = "󰣶  {ifname}";
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
          format = "  {:%H:%M}";
          format-alt = "󰃭 {:%Y-%m-%d}";
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
        border-bottom: solid 2px #2D2B40;
        font-family: 'Inter', 'RobotoMono Nerd Font';
        font-size: 14px;
      }

      tooltip {
        background-color: #2D2B40;
        color: #CBE3E7;
      }

      #workspaces button {
        padding: 2px 8px;
        margin: 0 8px 0 0;
      }

      #workspaces button.active {
        background-color: #2D2B40;
      }

      #taskbar button.active {
        background-color: #2D2B40;
      }

      .modules-right * {
        padding: 0 8px;
        margin: 0 0 0 8px;
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

      #tray {
        background-color: #2D2B40;
        padding: 0 8px 0 8px;
      }
      
      #tray * {
        padding: 0;
        margin: 0;
      }
    '';
  };
}

