{ lib, pkgs, config, inputs, ... }:

{

  imports = [
    ../waybar.nix
    ../dunst.nix
  ];

  home.packages = with pkgs; [ 
    playerctl
    swaybg
    wl-clipboard
    grim
    slurp
    inputs.hyprland-contrib.packages.x86_64-linux.grimblast
    neofetch 
    rofi-emoji
    libnotify
  ];

  programs.wofi.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    xwayland.enable = true;
    settings = {
      exec-once = [
        "hyprctl setcursor Bibata-Modern-Ice 22"
        "nm-applet"
        "swaybg -i ~/wallpaper -m fill"
        "synology-drive"
        "waybar"
        "[workspace 2 silent] firefox"
        "webcord"
        "[workspace special:term silent] kitty --title='kitty-scratch' --hold"
        "kitty"
        "remind -z -k':notify-send \"Reminder!\" %s' ~/00-09-System/02-Logs/02.10-Journal/"
      ];

      workspace = lib.lists.flatten (map
                (m: 
                  map (w: "${w}, monitor:${m.name}") (m.workspaces)
                )
                (config.monitors));

      env = ["XCURSOR_SIZE,24"];

      general = {
        gaps_in = 5;
        gaps_out = 5;
        border_size = 2;
        "col.active_border" = "rgb(78A8FF) rgb(7676FF) 45deg";
        "col.inactive_border" = "rgba(585272aa)";
        layout = "dwindle";
        resize_on_border = true;
      };

      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      master = {
        orientation = "left";
      };

      decoration = {
        rounding = 0;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
          new_optimizations = true;
        };
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
        "col.shadow" = "rgba(1a1a1aee)";
      };

      group  = {
        "col.border_active" = "rgba(63F2F1aa)";
        "col.border_inactive" = "rgba(585272aa)";

        groupbar = {
          font_family = "Iosevka";
          font_size = 13;
          "col.active" = "rgba(63F2F1aa)";
          "col.inactive" = "rgba(585272aa)";
        };
      };

      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      input = {
        kb_layout = "us";
        kb_variant = config.keyboard.variant;
        kb_options = config.keyboard.options;
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
      };

      gestures = {
        workspace_swipe = true;
      };

      "device:getech-huge-trackball-1" = {
        "scroll_method" = "on_button_down";
        "scroll_button" = 279;
        "natural_scroll" = true;
      };

      monitor = map 
          (m:
            let
              resolution = "${toString m.width}x${toString m.height}@${toString m.refreshRate}";
              position = "${toString m.x}x${toString m.y}";
            in
            "${m.name},${if m.enabled then "${resolution},${position},${toString m.scale}" else "disable"}"
          )
          (config.monitors);

      animations = {
        enabled = true;
        bezier = [
          "overshot,0.05,0.9,0.1,1.1"
          "overshot,0.13,0.99,0.29,1."
        ];
        animation = [
          "windows,1,7,overshot,slide"
          "border,1,10,default"
          "fade,1,10,default"
          "workspaces,1,7,overshot,slidevert"
        ];
      };

      windowrulev2 = [
       "workspace 1,class:kitty"
       "workspace 2,title:^(Mozilla Firefox)(.*)$"
       "workspace special:notes,title:^(kitty-delta)"
       "workspace special:term,title:^(kitty-scratch)"
       "workspace 3,class:Slack"
       "workspace 3,class:WebCord"
       "float,title:(GnuCash Tip Of The Day)"
       "float,title:(Firefox — Sharing Indicator)"
      ];

      "$mainMod" = "SUPER";
      bind = [
        "ALT, Return, exec, kitty"
        "$mainMod, w, killactive,"
        "$mainMod SHIFT, q, exit,"
        "$mainMod, f, fullscreen, 0"
        "$mainMod, m, fullscreen, 1"
        "$mainMod SHIFT, t, togglefloating,"
        "ALT, d, exec, wofi --show drun -I"
        "ALT, e, exec, wofi-emoji"
        "$mainMod, e, exec, thunar"
        "$mainMod, P, pseudo, # dwindle"
        "= $mainMod, J, togglesplit, # dwindle"
        "$mainMod, s, togglespecialworkspace, notes"
        "$mainMod SHIFT, S, movetoworkspace, special:notes"
        "$mainMod CTRL, t, togglespecialworkspace, term"
        "$mainMod, g, togglegroup"
        "$mainMod, TAB, changegroupactive, f"
        "$mainMod SHIFT, TAB, changegroupactive, b"

        "$mainMod, h, movefocus, l"
        "$mainMod, l, movefocus, r"
        "$mainMod, k, movefocus, u"
        "$mainMod, j, movefocus, d"

        "$mainMod CTRL, h, swapwindow, l"
        "$mainMod CTRL, l, swapwindow, r"
        "$mainMod CTRL, k, swapwindow, u"
        "$mainMod CTRL, j, swapwindow, d"
        "$mainMod ALT, h, moveintogroup, l"
        "$mainMod ALT, l, moveintogroup, r"
        "$mainMod ALT, k, moveintogroup, u"
        "$mainMod ALT, j, moveintogroup, d"

        "$mainMod, 1, workspace, 1"
        "$mainMod, 2, workspace, 2"
        "$mainMod, 3, workspace, 3"
        "$mainMod, 4, workspace, 4"
        "$mainMod, 5, workspace, 5"
        "$mainMod, 6, workspace, 6"
        "$mainMod, 7, workspace, 7"
        "$mainMod, 8, workspace, 8"
        "$mainMod, 9, workspace, 9"
        "$mainMod, 0, workspace, 10"

        "$mainMod ALT, 1, movetoworkspace, 1"
        "$mainMod ALT, 2, movetoworkspace, 2"
        "$mainMod ALT, 3, movetoworkspace, 3"
        "$mainMod ALT, 4, movetoworkspace, 4"
        "$mainMod ALT, 5, movetoworkspace, 5"
        "$mainMod ALT, 6, movetoworkspace, 6"
        "$mainMod ALT, 7, movetoworkspace, 7"
        "$mainMod ALT, 8, movetoworkspace, 8"
        "$mainMod ALT, 9, movetoworkspace, 9"
        "$mainMod ALT, 0, movetoworkspace, 10"
        ", XF86AudioPrev, exec, playerctl previous"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPlay, exec, playerctl play-pause"

        "$mainMod ALT CTRL, equal, exec, dunstctl set-paused toggle"
        "$mainMod ALT CTRL, bracketright, exec, systemctl reboot"

        "$mainMod ALT CTRL SHIFT, 1, exec, grimblast copy area"
        "$mainMod ALT CTRL SHIFT, 2, exec, grimblast save area"
        "$mainMod ALT CTRL SHIFT, 3, exec, grimblast copy active"
        "$mainMod ALT CTRL SHIFT, 4, exec, grimblast copy output"
      ];

      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
    };
  };
}
