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
      "in" = "task add +in";
    };

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
          ready = {
            columns = "id,project,tags,due.relative,until.remaining,scheduled.formatted,description,urgency";
            labels = "ID,Pr,Tags,Due,Until,Sched,Desc,Urg";
          };
        };
        context = {
          work = "+dk or +car";
          personal = "-dk";
        };
        urgency = {
          project.coefficient = 0;
          blocking.coefficient = 0;
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
