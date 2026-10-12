{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.delta.openlinkhub;
  pkg = config.delta.openlinkhub.package;
in
{
  options.delta.openlinkhub = {
    enable = lib.mkEnableOption "openlinkhub";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.openlinkhub;
    };
  };

  config = lib.mkIf cfg.enable {
    users.users.openlinkhub = {
      isSystemUser = true;
      group = "openlinkhub";
    };
    users.groups.openlinkhub = { };

    systemd.services.OpenLinkHub = {
      description = "Open source interface for iCUE LINK System Hub, Corsair AIOs and Hubs";
      after = [ "sleep.target" ];
      wantedBy = [ "multi-user.target" ];
      script = ''
        # mkdir -p database
        # chmod -R u+w database
        # cp -rn ${pkg}/share/OpenLinkHub/database/. database/
        #
        # mkdir -p static web
        # chmod -R u+w static web
        # cp -r ''${pkg}/share/OpenLinkHub/static/. static/
        # cp -r ''${pkg}/share/OpenLinkHub/web/. web/

        ${lib.getExe pkg}
      '';
      reload = "kill -s HUB $MAINPID";
      path = [ pkgs.pciutils ];

      serviceConfig = {
        User = "openlinkhub";
        Group = "openlinkhub";
        RestartSec = 5;
        StateDirectory = "OpenLinkHub";
        WorkingDirectory = "/var/lib/OpenLinkHub";
        ReadWritePaths = [ "/var/lib/OpenLinkHub" ];
      };
    };

    environment.systemPackages = [ pkg ];

    services.udev.packages = [ pkg ];
  };
}
