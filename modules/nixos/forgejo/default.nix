{
  config,
  lib,
  ...
}:

let
  cfg = config.delta.forgejo;
in
{
  options.delta.forgejo = {
    enable = lib.mkEnableOption "forgejo";
    domain = lib.mkOption {
      type = lib.types.str;
      description = "domain name for the forgejo web interface";
    };
    server_port = lib.mkOption {
      type = lib.types.int;
      description = "port for web server";
      default = 9712;
    };
    ssh_domain = lib.mkOption {
      type = lib.types.str;
      description = "domain name for the forgejo ssh interface";
      default = cfg.delta.forgejo.domain;
    };
    ssh_port = lib.mkOption {
      type = lib.types.int;
      description = "port for ssh server";
      default = 2222;
    };
  };

  config = lib.mkIf cfg.enable {
    fileSystems."/mnt/git" = {
      device = "//oracle.home.arpa/repos";
      fsType = "cifs";
      options =
        let
          automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s,user,users";
        in
        [
          "${automount_opts},credentials=${config.sops.secrets.smb-creds.path},uid=${toString config.users.users.forgejo.uid},gid=${toString config.users.groups.forgejo.gid}"
        ];
    };

    users.groups.forgejo = {
      gid = 1100;
    };

    users.users.forgejo = {
      home = config.services.forgejo.stateDir;
      useDefaultShell = true;
      isSystemUser = true;
      group = "forgejo";
      uid = 1100;
    };

    services.forgejo = {
      enable = true;
      lfs.enable = true;
      lfs.contentDir = "/mnt/git/lfs";
      stateDir = "/var/zion-data/forgejo";
      repositoryRoot = "/var/zion-data/forgejo-repos";
      database.type = "sqlite3";
      dump.enable = false;
      group = "forgejo";
      user = "forgejo";
      # settings.server.DOMAIN = "git.gorgon-procyon.ts.net";
      settings.server.DOMAIN = cfg.domain;
      settings.server.ROOT_URL = "https://${cfg.domain}";
      settings.server.HTTP_ADDR = "127.0.0.1";
      settings.server.HTTP_PORT = cfg.server_port;
      settings.service.DISABLE_REGISTRATION = false;
      settings.server.START_SSH_SERVER = true;
      settings.server.SSH_PORT = cfg.ssh_port;
      settings.server.SSH_LISTEN_PORT = cfg.ssh_port;
      # TODO:
      settings.server.SSH_DOMAIN = cfg.ssh_domain;
      settings.session.COOKIE_SECURE = true;
      settings.mailer.ENABLED = false;
      settings.actions.ENABLED = false;
      useWizard = false;
    };

    services.caddy.virtualHosts."${config.services.forgejo.settings.server.ROOT_URL}" = {
      extraConfig = with config.services.forgejo.settings; ''
        bind tailscale/git
        tailscale_auth
        reverse_proxy ${server.HTTP_ADDR}:${toString server.HTTP_PORT} {
          header_up X-Webauth-User {http.auth.user.tailscale_user}
        }
      '';
    };

    networking.firewall.allowedTCPPorts = [
      config.services.forgejo.settings.server.HTTP_PORT
      config.services.forgejo.settings.server.SSH_PORT
    ];
  };
}
