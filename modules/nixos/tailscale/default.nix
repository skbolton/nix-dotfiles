{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.tailscale;
in
{
  options.delta.tailscale = with types; {
    enable = mkEnableOption "tailscale";
  };

  config = mkIf cfg.enable {
    services.tailscale.enable = true;
    environment.systemPackages = with pkgs; [ tailscale ];
  };
}
