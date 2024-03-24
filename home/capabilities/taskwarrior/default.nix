{ pkgs, ... }:

{
  programs.taskwarrior = {
    enable = true;
    colorTheme = ./embark.theme;
    config = {
      alias = {
        "@" = "context";
      };
      report = {
        next = {
          filter = "-milestone +READY limit:20";
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
