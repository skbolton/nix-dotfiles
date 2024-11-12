{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.lang.nix;
in
{
  options.delta.lang.nix = with types; {
    enable = mkEnableOption "Nix Language support";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      nil
      nixpkgs-fmt
    ];
  };
}
