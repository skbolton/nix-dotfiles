{pkgs, ...}:
{
  systemd.user.services.openrgb-profile = {
    Unit.Description = "Open RGB profile launcher";
    Install.WantedBy = [ "graphical-session.target" ];
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.openrgb-with-all-plugins}/bin/openrgb --profile blood-moon";
    };
  };

  xdg.configFile."OpenRGB/blood-moon.orp".source = ./blood-moon.orp;
}
