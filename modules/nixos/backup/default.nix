{ pkgs, config, lib, ... }:

with lib;
let
  cfg = config.delta.backup;
in
{
  options.delta.backup = with types; {
    enable = mkEnableOption "backup";
    extraGroups = mkOption {
      type = listOf str;
      default = [ ];
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      rsync
    ];

    users.groups.backup = { name = "backup"; };

    users.users.backup = {
      isNormalUser = true;
      group = "backup";
      extraGroups = cfg.extraGroups;
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIETNohmWNcUqYYSPGx3av5+UsC66u7Dku9iHEBDf1dzS stephen@bitsonthemind.com"
      ];
    };
  };
}

