{ lib, config, ... }:

let
  cfg = config.delta.sops;
in
{
  options.delta.sops = {
    enable = lib.mkEnableOption "home-sops";
  };

  config = lib.mkIf cfg.enable {
    sops = {
      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      defaultSopsFile = ../../../secrets/home/secrets.yaml;
    };
  };

}
