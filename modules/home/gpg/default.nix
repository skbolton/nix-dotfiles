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

    enableExtraSocket = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Whether to enable extra socket";
    };

    agentPassthrough = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = ''
        Whether ssh keys come from a gpg agent forwarded over ssh instead of a
        local agent. Points SSH_AUTH_SOCK at the gpg agent socket and stops
        gpg from starting a local agent.
      '';
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
        no-autostart = cfg.agentPassthrough;
      };
      scdaemonSettings = {
        disable-ccid = true;
      };
    };

    services.gpg-agent = {
      enable = cfg.enable;
      verbose = true;
      # home manager enableSshSupport will start the agent if enabled
      enableSshSupport = !cfg.agentPassthrough;
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

    services.gpg-agent.extraConfig = lib.mkIf cfg.agentPassthrough ''
      enable-ssh-support
    '';

    home.sessionVariablesExtra = lib.mkIf cfg.agentPassthrough ''
      unset SSH_AGENT_PID
      export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
    '';
  };
}
