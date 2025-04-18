{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.desktop.qt;
in
{
  options.delta.desktop.qt = with types; {
    enable = mkEnableOption "QT Themeing";
  };

  config = {
    qt = {
      enable = cfg.enable;
      platformTheme.name = "adwaita";
      style.name = "Adwaita";
    };
  };
}

