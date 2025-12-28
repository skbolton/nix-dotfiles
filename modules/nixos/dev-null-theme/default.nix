{ config, lib, ... }:

with lib;
let
  cfg = config.delta.dev-null-theme;
in
{
  options.delta.dev-null-theme = with types; {
    enable = mkEnableOption "dev-null-theme";
  };

  config = mkIf cfg.enable {
    stylix.enable = true;
    stylix.autoEnable = true;
    stylix.base16Scheme = {
      system = "base16";
      name = "dev-null";
      author = "Stephen Bolton";
      variant = "dark";
      # Background
      palette.base00 = "#161616";
      # Lighter Background - status bars
      palette.base01 = "#1B1B1B";
      # Selection Background
      palette.base02 = "#252525";
      # Comments, Invisibles, Line Highlighting
      palette.base03 = "#484848";
      # Dark Foreground - Statusbars?
      palette.base04 = "#111111";
      # Default Foreground
      palette.base05 = "#C6C6C6";
      # Light Foreground
      palette.base06 = "#F4F4F4";
      # Lightest Foreground
      palette.base07 = "#FFFFFF";
      # Red and brignt red - Variables Diff
      palette.base08 = "#FF7EB6";
      # Orange - integers boolean constants
      palette.base09 = "#FFF395";
      # Yellow - classes, markup bold, search background
      palette.base0A = "#FF5D62";
      # Green
      palette.base0B = "#3DDBD9";
      # Cyan
      palette.base0C = "#82CFFF";
      # Blue
      palette.base0D = "#78A9FF";
      # Magenta
      palette.base0E = "#D4BBFF";
      # Dark Red
      palette.base0F = "#D02670";
    };
  };

}

