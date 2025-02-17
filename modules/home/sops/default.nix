{ lib, config, ... }:

with lib;
let
  cfg = config.delta.sops;
in
{
  options.delta.sops = with types; {
    enable = mkEnableOption "home-sops";
    user = mkOption {
      type = str;
      default = "orlando";
    };
  };

  config = mkIf cfg.enable {
    sops = {
      age.keyFile = "/home/${cfg.user}/.config/sops/age-key.txt";
      defaultSopsFile = ../../../secrets/home-secrets.yaml;
      secrets.taskwarrior-sync-server-credentials = {
        path = "%r/taskwarrior-sync-server-credentials.txt";
      };
    };
  };

}
