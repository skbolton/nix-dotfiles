{ lib, config, ... }:

with lib;
let
  cfg = config.delta.desktop.nm-applet;
in
{
  options.delta.desktop.nm-applet = with types; {
    enable = mkEnableOption "nm-applet";
  };

  config = {
    services.network-manager-applet.enable = cfg.enable;
  };
}
