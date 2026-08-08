{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.delta.tailscale;
in
{
  options.delta.tailscale = {
    enable = lib.mkEnableOption "tailscale";
    package = lib.mkPackageOption pkgs "tailscale" {
      default = "tailscale";
    };
  };

  config = lib.mkIf cfg.enable {
    services.tailscale.enable = true;
    services.tailscale.package = cfg.package;
    environment.systemPackages = [ cfg.package ];
  };
}
