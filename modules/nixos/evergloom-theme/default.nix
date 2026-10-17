{ config, lib, ... }:

let
  cfg = config.delta.evergloom-theme;
in
{
  options.delta.evergloom-theme = {
    enable = lib.mkEnableOption "evergloom-theme";
  };

  config = lib.mkIf cfg.enable {
    stylix.enable = true;
    stylix.autoEnable = true;
    stylix.base16Scheme = {
      system = "base16";
      name = "evergloom";
      author = "Stephen Bolton";
      variant = "dark";
      # Background
      palette.base00 = "#011627";
      # Lighter Background - status bars
      palette.base01 = "#0b253a";
      # Selection Background
      palette.base02 = "#1d3b53";
      # Comments, Invisibles, Line Highlighting
      palette.base03 = "#637777";
      # Dark Foreground - Statusbars?
      palette.base04 = "#80a4c2";
      # Default Foreground
      palette.base05 = "#d6deeb";
      # Light Foreground
      palette.base06 = "#d6deeb";
      # Lightest Foreground
      palette.base07 = "#ffffff";
      # Red and brignt red - Variables Diff
      palette.base08 = "#ef5075";
      # Orange - integers boolean constants
      palette.base09 = "#ffeb95";
      # Yellow - classes, markup bold, search background
      palette.base0A = "#addb67";
      # Green
      palette.base0B = "#3CD6A8";
      # Cyan
      palette.base0C = "#21c7a8";
      # Blue
      palette.base0D = "#82aaff";
      # Magenta
      palette.base0E = "#c792ea";
      # Dark Red
      palette.base0F = "#ea1a4a";
    };
  };

}
