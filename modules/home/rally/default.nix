{ lib, config, pkgs, ... }:
let
  cfg = config.delta.rally;
in
with lib;
{
  options.delta.rally = with types; {
    enable = mkEnableOption "rally";
    rallypoints = mkOption {
      type = listOf str;
    };
  };

  config = mkIf cfg.enable {
    home.sessionVariables = {
      RALLYPOINTS = join ":" cfg.rallypoints;
    };

    home.packages = [
      pkgs.delta.rally
    ];
  };
}
