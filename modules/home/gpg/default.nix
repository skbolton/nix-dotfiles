{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.gpg;
in
{
  options.delta.gpg = with types; {
    enable = mkEnableOption "gpg";

    autostart = mkOption {
      type = bool;
      default = true;
      description = "whether to auto start agent";
    };

    enableExtraSocket = mkOption {
      type = bool;
      default = true;
      description = "Whether to enable extra socket";
    };
  };

  config = mkIf cfg.enable {
    programs.gpg = {
      enable = true;
      publicKeys = [
        {
          source = ./stephen-bitsonthemind.asc;
          trust = 5;
        }
      ];
      settings = {
        throw-keyids = true;
        no-autostart = !cfg.autostart;
      };
      scdaemonSettings = {
        disable-ccid = true;
      };
    };

    services.gpg-agent = {
      enable = true;
      verbose = true;
      enableSshSupport = true;
      enableExtraSocket = cfg.enableExtraSocket;
      enableZshIntegration = config.programs.zsh.enable;
      pinentryPackage = pkgs.pinentry-gnome3;
      defaultCacheTtl = 60;
      maxCacheTtl = 120;
      enableScDaemon = true;
      grabKeyboardAndMouse = false;
      sshKeys = [
        "B189B794F1B984F63BAFA6785F3B2EE2F3458934"
      ];
    };
  };
}