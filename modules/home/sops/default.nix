{ lib, config, ... }:

with lib;
let
  cfg = config.delta.sops;
in
{
  options.delta.sops = with types; {
    enable = mkEnableOption "home-sops";
  };

  config = mkIf cfg.enable {
    sops = {
      age.keyFile = "${config.home.homeDirectory}/.config/sops/age/keys.txt";
      defaultSopsFile = ../../../secrets/home-secrets.yaml;
      secrets.taskwarrior-sync-server-credentials = {
        path = "%r/taskwarrior-sync-server-credentials.txt";
      };
      secrets.fastmail-vdirsync-password = {
        path = "%r/fastmail-vdirsync-password.txt";
      };
      secrets.aichat-env.path = "%r/aichat/.env";
      secrets.ollama-api-creds.path = "%r/ollama-api-creds.txt";
    };
  };

}
