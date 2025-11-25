{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.tailscale;
in
{
  options.delta.tailscale = with types; {
    enable = mkEnableOption "tailscale";
    package = mkPackageOption pkgs "tailscale" {
      default = "tailscale";
    };
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;
    services.tailscale.package = cfg.package;
    environment.systemPackages = [ cfg.package ];
  };
}
