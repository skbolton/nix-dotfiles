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
      delta.tw-calendar
      (
        pkgs.writeShellScriptBin "tw-cal-export" ''
          if [ ! -d ~/Calendars/Tasks ]; then
            mkdir ~/Calendars/Tasks
            echo "#63F2F1" > ~/Calendars/Tasks/color
            mkdir ~/Calendars/Deadlines
            echo "#F48FB1" > ~/Calendars/Deadlines/color
          else
            rm -rf ~/Calendars/Tasks/
            rm -rf ~/Calendars/Deadlines/
            mkdir ~/Calendars/Tasks
            echo "#63F2F1" > ~/Calendars/Tasks/color
            mkdir ~/Calendars/Deadlines
            echo "#F48FB1" > ~/Calendars/Deadlines/color
          fi
          ${pkgs.delta.tw-calendar}/bin/task-ical convert --no-alarm --filter "status:pending +SCHEDULED" | ${pkgs.khal}/bin/khal import -a Tasks --batch
          ${pkgs.delta.tw-calendar}/bin/task-ical convert --no-alarm --filter "status:pending +DUE" | ${pkgs.khal}/bin/khal import -a Deadlines --batch
        ''
      )
    ] ++ optional cfg.gui morgen;

    xdg.configFile."khal/config".text = /* ini */ ''
      [calendars]
      [[calendars]]
      path = ~/Calendars/**
      type = discover

      [view]
      event_format = {calendar-color}{cancelled}{start}-{end} {title}{repeat-symbol}{reset}
      agenda_event_format = {calendar-color}{cancelled}{start}-{end} {title}{repeat-symbol}{reset}
    '';

    xdg.configFile."vdirsyncer/config".text = ''
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
      password.fetch = ["command", "${pkgs.coreutils}/bin/cat", "~/.config/sops-nix/secrets/fastmail-vdirsync-password"]

      [storage fastmail_calendar_local]
      type = "filesystem"
      path = "~/Calendars/Fastmail"
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
          pkgs.writeShellScript "vdirsyncer-discover-yes" ''
            ${pkgs.coreutils}/bin/yes | ${pkgs.vdirsyncer}/bin/vdirsyncer discover
            ${pkgs.vdirsyncer}/bin/vdirsyncer sync
            ${pkgs.vdirsyncer}/bin/vdirsyncer metasync
          '';
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

