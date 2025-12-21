{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.delta.inspired-theme;
in
{
  options.delta.inspired-theme = with types; {
    enable = mkEnableOption "inspired-theme";
  };

  config = mkIf cfg.enable {
    stylix.enable = true;
    stylix.autoEnable = true;
    stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/github.yaml";
  };

}

