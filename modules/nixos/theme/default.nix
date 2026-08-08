{ lib, config, ... }:

let
  cfg = config.delta.theme;
in
{
  options.delta.theme = {
    enable = lib.mkEnableOption "themeing";
    palette = lib.mkOption {
      type = lib.types.enum [
        "inspired"
        "embark"
        "dev-null"
      ];
      default = "embark";
    };
  };

  config = lib.mkIf cfg.enable {
    delta = {
      "embark-theme".enable = cfg.palette == "embark";
      "inspired-theme".enable = cfg.palette == "inspired";
      "dev-null-theme".enable = cfg.palette == "dev-null";
    };
  };
}
