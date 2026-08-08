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
      default = pkgs.delta.openlinkhub;
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
        for dir in database static web; do
          if ! [[ -d $dir ]]; then
            cp -r ${pkg}/share/OpenLinkHub/$dir .
            chmod -R u+w $dir
          fi
        done
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
