{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.calendar;
in
{
  options.delta.calendar = with types; {
    enable = mkEnableOption "calendar support";
    gui = mkOption {
      type = bool;
      default = true;
    };
    sync = mkOption {
      type = bool;
      default = true;
    };
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      vdirsyncer
      khal
      delta.agenda
    ] ++ optional cfg.gui morgen;

    xdg.configFile."khal/config".text = /* ini */ ''
      [calendars]
      [[calendars]]
      path = ~/Calendars/*
      type = discover

      [view]
      event_format = {calendar-color}{cancelled}{start}-{end} {title}{repeat-symbol}{reset}
      agenda_event_format = {calendar-color}{cancelled}{start}-{end} {title}{repeat-symbol}{reset}
    '';

    xdg.configFile."vdirsyncer/calendar.conf".text = ''
      [general]
      status_path = "~/.local/state/vdirsyncer/status"

      [pair fastmail_calendar]
      a = "fastmail_calendar_remote"
      b = "fastmail_calendar_local"
      collections = ["from a", "from b"]
      conflict_resolution = "a wins"
      metadata = ["color", "displayname"]

      [storage fastmail_calendar_remote]
      type = "caldav"
      url = "https://caldav.fastmail.com/"
      username = "stephen@bitsonthemind.com"
      password.fetch = ["command", "cat", "~/.config/sops-nix/secrets/fastmail-vdirsync-password"]

      [storage fastmail_calendar_local]
      type = "filesystem"
      path = "~/Calendars"
      fileext = ".ics"
    '';

    systemd.user.services.vdirsyncer = mkIf cfg.sync {
      Unit = {
        Description = "vdirsyncer calendar&contacts synchronization";
        PartOf = [ "network-online.target" ];
        After = [ "sops-nix.service" ];
      };

      Service = {
        Type = "oneshot";
        ExecStart =
          (
            pkgs.writeShellScript "vdirsyncer-discover-yes" ''
              set -e
              yes | ${pkgs.vdirsyncer}/bin/vdirsyncer --config="$HOME/.config/vdirsyncer/calendar.conf" discover
              ${pkgs.vdirsyncer}/bin/vdirsyncer --config="$HOME/.config/vdirsyncer/calendar.conf" sync
              ${pkgs.vdirsyncer}/bin/vdirsyncer --config="$HOME/.config/vdirsyncer/calendar.conf" metasync
            ''
          );
      };
    };

    systemd.user.timers.vdirsyncer = mkIf cfg.sync {
      Unit = { Description = "vdirsyncer calendar&contacts synchronization"; };

      Timer = {
        OnBootSec = "1min";
        OnCalendar = "*:0/15";
        Unit = "vdirsyncer.service";
      };

      Install = { WantedBy = [ "timers.target" ]; };
    };
  };
}

