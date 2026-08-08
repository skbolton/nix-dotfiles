{
  lib,
  config,
  pkgs,
  ...
}:

let
  cfg = config.delta.gpg;
in
{
  options.delta.gpg = {
    enable = lib.mkEnableOption "gpg";

    autostart = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "whether to auto start agent";
    };

    enableExtraSocket = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable extra socket";
    };

    enableSshSupport = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable extra socket";
    };

    pinentry = lib.mkPackageOption pkgs "pinentry" { default = "pinentry-gnome3"; };
  };

  config = lib.mkIf cfg.enable {
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
      enable = cfg.enable;
      verbose = true;
      enableSshSupport = cfg.enableSshSupport;
      enableExtraSocket = cfg.enableExtraSocket;
      enableZshIntegration = config.programs.zsh.enable;
      pinentry.package = cfg.pinentry;
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
