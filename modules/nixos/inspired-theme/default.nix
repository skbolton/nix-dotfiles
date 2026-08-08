{
  pkgs,
  config,
  lib,
  ...
}:

let
  cfg = config.delta.inspired-theme;
in
{
  options.delta.inspired-theme = {
    enable = lib.mkEnableOption "inspired-theme";
  };

  config = lib.mkIf cfg.enable {
    stylix.enable = true;
    stylix.autoEnable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/github.yaml";
  };

}
