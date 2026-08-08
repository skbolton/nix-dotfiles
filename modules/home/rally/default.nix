{
  lib,
  config,
  pkgs,
  ...
}:
let
  cfg = config.delta.rally;
in
{
  options.delta.rally = {
    enable = lib.mkEnableOption "rally";
    rallypoints = lib.mkOption {
      type = lib.types.listOf lib.types.str;
    };
  };

  config = lib.mkIf cfg.enable {
    home.sessionVariables = {
      RALLYPOINTS = lib.join ":" cfg.rallypoints;
    };

    home.packages = [
      pkgs.delta.rally
    ];
  };
}
