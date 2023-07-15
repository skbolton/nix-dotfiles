{ kb_variant ? "", kb_options ? "", ... }:
''
# See https://wiki.hyprland.org/Configuring/Monitors/

# See https://wiki.hyprland.org/Configuring/Keywords/ for more
monitor=DP-1,preferred,auto,1.25
monitor=DP-2,preferred,auto,1.25

workspace = 1, monitor:DP-2, default:true
workspace = 2, monitor:DP-1, default:true
workspace = 3, monitor:DP-1
workspace = 4, monitor:DP-2

windowrulev2 = workspace 1,class:kitty
windowrulev2 = workspace 2,title:^(Mozilla Firefox)(.*)$
windowrulev2 = workspace special:notes,title:^(Logseq)
windowrulev2 = workspace 3,class:Slack
windowrulev2 = workspace 3,class:discord
windowrulev2 = float,title:(GnuCash Tip Of The Day)
windowrulev2 = float,title:(Firefox — Sharing Indicator)

exec-once = dunst
exec-once = hyprctl setcursor Bibata-Modern-Ice 22
exec-once = synology-drive
exec-once = waybar
exec-once = [workspace 2 silent] firefox
exec-once = [workspace special:notes silent] logseq
exec-once = kitty

# For all categories, see https://wiki.hyprland.org/Configuring/Variables/
input {
    kb_layout = us
    kb_variant = ${kb_variant}
    kb_model =
    kb_options = ${kb_options}
    kb_rules =

    follow_mouse = 1

    touchpad {
        natural_scroll = true
    }

    sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
}

device:getech-huge-trackball-1 {
  scroll_method = on_button_down
  scroll_button = 279
  natural_scroll = true
}

general {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    gaps_in = 5
    gaps_out = 5
    border_size = 2
    col.active_border = rgb(a1efd3) rgb(d4bfff) 45deg
    col.inactive_border = rgba(585272aa)

    layout = master
}

decoration {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more

    rounding = 0
    blur = true
    blur_size = 3
    blur_passes = 1
    blur_new_optimizations = true

    drop_shadow = true
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

animations {
    enabled = true

    # Some default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

    bezier = overshot, 0.13, 0.99, 0.29, 1.1
    animation = windows, 1, 4, overshot, slide
    animation = windowsOut, 1, 5, default, popin 80%
    animation = border, 1, 5, default
    animation = fade, 1, 8, default
    animation = workspaces, 1, 6, overshot, slidevert
}

dwindle {
    # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
    pseudotile = true # master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
    preserve_split = true # you probably want this
}

master {
    # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
    new_is_master = true
    orientation = top
}

gestures {
    # See https://wiki.hyprland.org/Configuring/Variables/ for more
    workspace_swipe = false
}

misc {
 disable_hyprland_logo = true
 disable_splash_rendering = true
}

# See https://wiki.hyprland.org/Configuring/Keywords/ for more
$mainMod = SUPER

# Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
bind = ALT, Return, exec, kitty
bind = $mainMod, w, killactive,
bind = $mainMod SHIFT, q, exit,
bind = $mainMod, f, fullscreen, 0
bind = $mainMod, m, fullscreen, 1
bind = $mainMod, t, togglefloating,
bind = ALT, d, exec, wofi --show drun -I
bind = ALT, e, exec, wofi-emoji
bind = $mainMod, e, exec, thunar
bind = $mainMod, P, pseudo, # dwindle
bind = $mainMod, J, togglesplit, # dwindle
bind = $mainMod, s, togglespecialworkspace, notes
bind = $mainMod SHIFT, S, movetoworkspace, special:notes

# Move focus with mainMod + vim arrow keys
bind = $mainMod, h, movefocus, l
bind = $mainMod, l, movefocus, r
bind = $mainMod, k, movefocus, u
bind = $mainMod, j, movefocus, d

# Move focus with mainMod + ctrl + vim arrow keys
bind = $mainMod CTRL, h, swapwindow, l
bind = $mainMod CTRL, l, swapwindow, r
bind = $mainMod CTRL, k, swapwindow, u
bind = $mainMod CTRL, j, swapwindow, d

# Switch workspaces with mainMod + [0-9]
bind = $mainMod, 1, workspace, 1
bind = $mainMod, 2, workspace, 2
bind = $mainMod, 3, workspace, 3
bind = $mainMod, 4, workspace, 4
bind = $mainMod, 5, workspace, 5
bind = $mainMod, 6, workspace, 6
bind = $mainMod, 7, workspace, 7
bind = $mainMod, 8, workspace, 8
bind = $mainMod, 9, workspace, 9
bind = $mainMod, 0, workspace, 10

# Move active window to a workspace with mainMod + SHIFT + [0-9]
bind = $mainMod ALT, 1, movetoworkspace, 1
bind = $mainMod ALT, 2, movetoworkspace, 2
bind = $mainMod ALT, 3, movetoworkspace, 3
bind = $mainMod ALT, 4, movetoworkspace, 4
bind = $mainMod ALT, 5, movetoworkspace, 5
bind = $mainMod ALT, 6, movetoworkspace, 6
bind = $mainMod ALT, 7, movetoworkspace, 7
bind = $mainMod ALT, 8, movetoworkspace, 8
bind = $mainMod ALT, 9, movetoworkspace, 9
bind = $mainMod ALT, 0, movetoworkspace, 10

# Scroll through existing workspaces with mainMod + scroll
bind = $mainMod, mouse_down, workspace, e+1
bind = $mainMod, mouse_up, workspace, e-1

# focus monitor by dir 
bind = $mainMod, bracketleft, focusmonitor, -1
bind = $mainMod, bracketright, focusmonitor, +1

# move window to monitor
bind = $mainMod ALT, bracketleft, movewindow, mon:-1
bind = $mainMod ALT, bracketright, movewindow, mon:+1

# Move/resize windows with mainMod + LMB/RMB and dragging
bindm = $mainMod, mouse:272, movewindow
bindm = $mainMod, mouse:273, resizewindow

# Media buttons
bind = , XF86AudioPrev, exec, playerctl previous
bind = , XF86AudioNext, exec, playerctl next
bind = , XF86AudioPlay, exec, playerctl play-pause

exec-once = swaybg -i ~/.local/share/wallpaper/1e1c31.png -m fill
''

