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
      calcure
    ] ++ optional cfg.gui morgen;

    xdg.configFile."calcure/config.ini".text = ''
      [Parameters]
      folder_with_datafiles = ~/.config/calcure
      calcurse_todo_file = ~/.local/share/calcurse/todo
      calcurse_events_file = ~/.local/share/calcurse/apts
      ics_event_files = ~/Calendars/
      taskwarrior_folder = ~/.task
      language = en
      default_view = calendar
      default_calendar_view = daily
      birthdays_from_abook = No
      show_keybindings = Yes
      privacy_mode = No
      show_weather = Yes
      show_metric_units = No
      minimal_today_indicator = Yes
      minimal_days_indicator = Yes
      minimal_weekend_indicator = Yes
      show_calendar_borders = No
      cut_titles_by_cell_length = No
      ask_confirmations = Yes
      ask_confirmation_to_quit = No
      use_unicode_icons = Yes
      show_current_time = No
      show_holidays = Yes
      show_nothing_planned = Yes
      holiday_country = UnitedStates
      use_persian_calendar = No
      one_timer_at_a_time = No
      start_week_day = 6
      weekend_days = 6,7
      refresh_interval = 1
      split_screen = No
      right_pane_percentage = 25
      journal_header = JOURNAL
      event_icon = 📅
      privacy_icon = •
      today_icon = 🌅
      birthday_icon = ★
      holiday_icon = ☘️
      hidden_icon = ...
      done_icon = ✔
      todo_icon = •
      important_icon = ‣
      timer_icon = ⌚
      separator_icon = │
      deadline_icon = ⚑

      [Colors]
      color_today = 2
      color_events = 7
      color_days = 4
      color_day_names = 4
      color_weekends = 1
      color_weekend_names = 1
      color_hints = 7
      color_prompts = 7
      color_confirmations = 1
      color_birthdays = 1
      color_holidays = 2
      color_deadlines = 3
      color_todo = 7
      color_done = 6
      color_title = 4
      color_calendar_header = 4
      color_important = 1
      color_unimportant = 6
      color_timer = 2
      color_timer_paused = 7
      color_time = 7
      color_weather = 2
      color_active_pane = 2
      color_separator = 7
      color_calendar_border = 7
      color_ics_calendars = 2,3,1,7
      color_background = -1

      [Styles]
      bold_today = Yes
      bold_days = No
      bold_day_names = No
      bold_weekends = No
      bold_weekend_names = No
      bold_title = No
      bold_active_pane = No
      underlined_today = No
      underlined_days = No
      underlined_day_names = No
      underlined_weekends = No
      underlined_weekend_names = No
      underlined_title = No
      underlined_active_pane = No
      strikethrough_done = No

      [Event icons]
      travel = ✈
      plane = ✈
      voyage = ✈
      flight = ✈
      airport = ✈
      trip = 🏕
      vacation = ⛱
      holiday = ⛱
      day-off = ⛱
      hair = ✂
      barber = ✂
      beauty = ✂
      nails = ✂
      game = ♟
      match = ♟
      play = ♟
      interview = 🎙️
      conference = 🎙️
      hearing = 🎙️
      date = ♥
      concert = ♪
      dance = ♪
      music = ♪
      rehearsal = ♪
      call = 🕻
      phone = 🕻
      zoom = 
      deadline = ⚑
      over = ⚑
      finish = ⚑
      end = ⚑
      doctor = ✚
      dentist = ✚
      medical = ✚
      hospital = ✚
      party = ☘
      bar = ☘
      museum = ⛬
      meet = ⛬
      talk = ⛬
      sport = ⛷
      gym = 🏋
      training = ⛷
      email = ✉
      letter = ✉
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
            ''
          );
      };
    };

    systemd.user.timers.vdirsyncer = mkIf cfg.sync {
      Unit = { Description = "vdirsyncer calendar&contacts synchronization"; };

      Timer = {
        OnBootSec = "1min";
        OnCalendar = "hourly";
        Unit = "vdirsyncer.service";
      };

      Install = { WantedBy = [ "timers.target" ]; };
    };
  };
}

