{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.tasks;
in
{
  options.delta.tasks = with types; {
    enable = mkEnableOption "tasks";
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [ todoist todoist-electron taskwarrior-tui ];

    programs.zsh.shellAliases = {
      t = "task";
      dk = "task add +dk";
      "in" = "task add +in";
    };

    programs.zsh.initExtra = /* bash */ ''
        function twait() {
          wait_til=$(date --iso-8601=minutes --date $2)
          task $1 modify wait:$wait_til
        }

      function tsnooze() {
        snooze=''${2:-"10 minutes"}
        twait $1 $snooze
      }
    '';


    programs.taskwarrior = {
      enable = true;
      package = pkgs.taskwarrior3;
      colorTheme = ./embark-taskwarrior.theme;
      config = {
        alias = {
          "@" = "context";
        };
        default.command = "next";
        report = {
          next.filter = "+READY limit:15";
          next.columns = "id,start.age,entry.age,depends,priority,project,tags,recur,scheduled.countdown,due.relative,until.remaining,description.count,urgency";
          ready = {
            columns = "id,project,tags,due.relative,until.remaining,scheduled.formatted,description,urgency";
            labels = "ID,Pr,Tags,Due,Until,Sched,Desc,Urg";
          };
          "in".columns = "id,description";
          "in".description = "Inbox";
          "in".filter = "status:pending limit:10 (+in)";
          "in".labels = "ID,Description";
        };
        context = {
          work = "+dk or +car";
          personal = "-dk";
        };
        urgency = {
          project.coefficient = 0;
          blocking.coefficient = 0;
          tags.coefficient = 0;
          annotations.coefficient = 0;
        };
        color = {
          alternate = "";
        };
        sync.server.origin = "https://tasks.zionlab.online";
      };

      # TODO: This is a secret that I could manage with nix if I figure out nix-sops
      extraConfig = ''
        include $HOME/Documents/Logbook/Trackers/Tasks/credentials
      '';
    };

    systemd.user.services.taskwarrior-sync = {
      Unit = { Description = "Taskwarrior sync"; };
      Service = {
        CPUSchedulingPolicy = "idle";
        IOSchedulingClass = "idle";
        ExecStart = "${pkgs.taskwarrior3}/bin/task synchronize";
      };
    };

    systemd.user.timers.taskwarrior-sync = {
      Unit = { Description = "Taskwarrior periodic sync"; };
      Timer = {
        Unit = "taskwarrior-sync.service";
        OnCalendar = "*:0/15";
      };
      Install = { WantedBy = [ "timers.target" ]; };
    };
  };
}
