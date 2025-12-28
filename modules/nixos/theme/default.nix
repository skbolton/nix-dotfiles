{ lib, config, ... }:

with lib;
let
  cfg = config.delta.theme;
in
{
  options.delta.theme = with types; {
    enable = mkEnableOption "themeing";
    palette = mkOption {
      type = enum [ "inspired" "embark" "dev-null" ];
      default = "embark";
    };
  };

  config = mkIf cfg.enable {
    delta = {
      "embark-theme".enable = cfg.palette == "embark";
      "inspired-theme".enable = cfg.palette == "inspired";
      "dev-null-theme".enable = cfg.palette == "dev-null";
    };
  };
}
