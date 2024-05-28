{ ... }:

{
  programs.zsh.shellAliases = {
    t = "task";
    chore = "task add proj:HOM";
    chores = "task proj:HOM";
    pdq = "task add proj:PDQ";
    pdqs = "task proj:PDQ";
    oss = "task add proj:OSS";
    osss = "task proj:OSS";
    cha = "task add proj:CHA";
    chas = "task proj:CHA";
  };

  programs.taskwarrior = {
    enable = true;
    colorTheme = ./embark.theme;
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
        work = "project:PDQ or proj:OSS or proj:CAR";
        personal = "project.not:PDQ";
      };
      urgency = {
        project.coefficient = 0;
        blocking.coefficient = 0;
      };
      color = {
        alternate = "";
      };
      taskd = {
        server = "app.wingtask.com:53589";
        key = "$HOME/Documents/Logbook/Trackers/Tasks/tasks@bitsonthemind.com.key.pem";
        certificate = "$HOME/Documents/Logbook/Trackers/Tasks/tasks@bitsonthemind.com.cert.pem";
        ca = "$HOME/Documents/Logbook/Trackers/Tasks/tasks@bitsonthemind.com.root-cert.pem";
      };
    };
    # TODO: This is a secret that I could manage with nix if I figure out nix-sops
    extraConfig = ''
      include $HOME/Documents/Logbook/Trackers/Tasks/credentials
    '';
  };

  services.taskwarrior-sync = {
    enable = true;
    frequency = "*:0/15";
  };
}
