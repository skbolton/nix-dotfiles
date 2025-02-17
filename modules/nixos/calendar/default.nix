{ ... }:

{
  services.vdirsyncer = {
    enable = true;
    jobs = {
      fastmail = {
        forceDiscover = true;
        config = {
          pairs = {
            fastmail_calendar = {
              a = "fastmail_calendar_remote";
              b = "fastmail_calendar_local";
              collections = [ "from a" ];
              conflict_resolution = "a wins";
            };
          };
          storages = {
            fastmail_calendar_remote = {
              type = "caldav";
              url = "https://caldav.fastmail.com";
              username = "stephen@bitsonthemind.com";
              password = "774a6a6b8b684v5r";
            };
            fastmail_calendar_local = {
              type = "filesystem";
              path = "/tmp/Calendars";
              fileext = ".ics";
            };
          };
        };
      };
    };
  };
}
