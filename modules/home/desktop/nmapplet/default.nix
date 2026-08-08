{ lib, config, ... }:

let
  cfg = config.delta.desktop.nm-applet;
in
{
  options.delta.desktop.nm-applet = {
    enable = lib.mkEnableOption "nm-applet";
  };

  config = {
    services.network-manager-applet.enable = cfg.enable;
  };
}
