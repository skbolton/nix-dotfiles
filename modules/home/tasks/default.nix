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
        task_id=$1
        shift
        wait_til=$(date --iso-8601=minutes --date "$*")
        task $task_id modify wait:$wait_til
      }

      function tmod() {
        task_id=$1
        shift
        task $task_id modify $@
      }

      function ttoday() {
        task sched.before:tom or +TODAY sched
      }

      function tweek() {
        if [[ $(date +%w) == "0" ]] && task sched.before:eow+6d or +WEEK sched || task sched.before:eow-1d or +WEEK sched
      }
      
      function tnweek() {
        task sched.after:eow-1d sched.before:eow+6d or due.after:eow-1d due.before:eow+6d sched
      }

      function tquarter() {
        task sched.before:$(${pkgs.delta.next-q}/bin/nextq)-1d or due.before:$(${pkgs.delta.next-q}/bin/nextq)-1d sched
      }

      function tnquarter() {
        task sched.after:$(${pkgs.delta.next-q}/bin/nextq)-1d \
          sched.before:$(${pkgs.delta.next-q}/bin/nextq)+12w-1d \
          or due.after:$(${pkgs.delta.next-q}/bin/nextq)-1d \
          due.before:$(${pkgs.delta.next-q}/bin/nextq)+12w-1d \
          sched
      }

      function tsnooze() {
        tasks=$1
        shift
        snooze=''${*:-"10 minutes"}
        twait $tasks $snooze
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
        default.command = "ready";
        report = {
          next.filter = "status:pending -WAITING -in limit:page";
          next.columns = "id,start.age,entry.age,depends,priority,project,tags,recur,scheduled.countdown,due.relative,until.remaining,description.count,urgency";
          ready = {
            columns = "id,project,tags,due.relative,until.remaining,scheduled.formatted,description.count,urgency";
            labels = "ID,Pr,Tags,Due,Until,Sched,Desc,Urg";
            filter = "+READY -in";
          };
          "in".columns = "id,description";
          "in".description = "Inbox";
          "in".filter = "status:pending limit:10 (+in)";
          "in".labels = "ID,Description";

          "sched".columns = "id,scheduled.formatted,scheduled.countdown,description,tags,due.relative";
          "sched".description = "Scheduled Tasks";
          "sched".filter = "status:pending (+SCHEDULED or due.any:'')";
          "sched".labels = "ID,Sched,Starts,Desc,Tags,Due";
          "sched".sort = "scheduled";
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
        sync.server.url = "https://tasks.zionlab.online";
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
