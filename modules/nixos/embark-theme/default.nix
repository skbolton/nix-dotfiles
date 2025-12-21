{ config, lib, ... }:

with lib;
let
  cfg = config.delta.embark-theme;
in
{
  options.delta.embark-theme = with types; {
    enable = mkEnableOption "embark-theme";
  };

  config = mkIf cfg.enable {
    stylix.enable = true;
    stylix.autoEnable = true;
    stylix.base16Scheme = {
      system = "base16";
      name = "Embark";
      author = "Stephen Bolton";
      variant = "dark";
      # Background
      palette.base00 = "#1e1c31";
      # Lighter Background - status bars
      palette.base01 = "#100e23";
      # Selection Background
      palette.base02 = "#3E3859";
      # Comments, Invisibles, Line Highlighting
      palette.base03 = "#3e3859";
      # Dark Foreground - Statusbars?
      palette.base04 = "#8A889d";
      # Default Foreground
      palette.base05 = "#cbe3e7";
      # Light Foreground
      palette.base06 = "#E2FAFE";
      # Lightest Foreground
      palette.base07 = "#ffffff";
      # Red and brignt red - Variables Diff
      palette.base08 = "#f48fb1";
      # Orange - integers boolean constants
      palette.base09 = "#f2b482";
      # Yellow - classes, markup bold, search background
      palette.base0A = "#ffe6b3";
      # Green
      palette.base0B = "#A1efd3";
      # Cyan
      palette.base0C = "#63f2f1";
      # Blue
      palette.base0D = "#91ddff";
      # Magenta
      palette.base0E = "#d4bfff";
      # Dark Red
      palette.base0F = "#f02e6e";
    };
  };

}

