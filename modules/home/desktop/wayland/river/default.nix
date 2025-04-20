{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.desktop.wayland.river;
in
{
  options.delta.desktop.wayland.river = with types; {
    enable = mkEnableOption "river";
  };

  config = {
    home.packages = mkIf cfg.enable [
      pkgs.wl-clipboard
      pkgs.river-filtile
    ];

    wayland.windowManager.river.enable = cfg.enable;
    wayland.windowManager.river.systemd.enable = cfg.enable;
    wayland.windowManager.river.xwayland.enable = cfg.enable;
    wayland.windowManager.river.extraConfig = /* sh */ ''
      export XDG_CURRENT_DESKTOP=river
      for i in $(seq 1 9)
        do
          tags=$((1 << ($i - 1)))

          # Super+[1-9] to focus tag [0-8]
          riverctl map normal Super $i set-focused-tags $tags

          # Super+Alt+[1-9] to tag focused view with tag [0-8]
          riverctl map normal Super+Mod5 $i set-view-tags $tags

          # Super+Control+[1-9] to toggle focus of tag [0-8]
          riverctl map normal Super+Control $i toggle-focused-tags $tags
      done

      riverctl default-layout filtile

      filtile \
        --output DP-1 main-location top, \
        --output HDMI-A-1 main-location left &
    '';
    wayland.windowManager.river.settings.focus-follows-cursor = "normal";
    wayland.windowManager.river.settings.set-cursor-warp = "on-output-change";
    wayland.windowManager.river.settings.border-width = 2;
    wayland.windowManager.river.settings.background-color = "0x1e1c31";
    wayland.windowManager.river.settings.border-color-unfocused = "0x63f2f100";
    wayland.windowManager.river.settings.border-color-focused = "0x2F2A47";
    wayland.windowManager.river.settings.border-color-urgent = "0xd4bfff";
    wayland.windowManager.river.settings.set-repeat = "50 300";
    wayland.windowManager.river.settings.keyboard-layout = "-variant colemak us";
    wayland.windowManager.river.settings.input."ploopy-corporation-ploopy-adept-trackball-mouse" = {
      natural-scroll = true;
    };
    wayland.windowManager.river.settings.xcursor-theme = "Bibata-Modern-Ice 22";
    wayland.windowManager.river.settings.declare-mode = [
      "locked"
      "resize"
      "normal"
      "passthrough"
    ];

    wayland.windowManager.river.settings.map.normal = {
      "Super asciicircum" = "enter-mode resize";
      "Super+Shift Q" = "exit";
      # Launchers
      "Alt D" = "spawn 'wofi --show drun -I'";
      "Mod5 D" = "spawn 'wofi --show drun -I'";
      "Super Return" = "spawn kitty";

      # Clients
      "Super W" = "close";

      "Super H" = "focus-view left";
      "Super L" = "focus-view right";
      "Super J" = "focus-view down";
      "Super K" = "focus-view up";

      "Super+Control H" = "swap left";
      "Super+Control L" = "swap right";
      "Super+Control J" = "swap down";
      "Super+Control K" = "swap up";

      # Outputs
      "Super bracketleft" = "focus-output left";
      "Super bracketright" = "focus-output right";

      "Super+Mod5 bracketleft" = "send-to-output left";
      "Super+Mod5 bracketright" = "send-to-output right";
    };

    wayland.windowManager.river.settings.map.resize = {
      "Super q" = "enter-mode normal";
      "Super h" = "resize horizontal -10";
      "Super j" = "resize vertical -10";
      "Super k" = "resize vertical 10";
      "Super l" = "resize horizontal 10";
    };

    wayland.windowManager.river.settings.rule-add."-title" = {
      "'*'" = "ssd";
      "'Mozilla Firefox*'" = "tags 2";
    };

    wayland.windowManager.river.settings.spawn = [ "firefox" ];
  };
}
