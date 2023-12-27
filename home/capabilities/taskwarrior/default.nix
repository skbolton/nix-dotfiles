{ pkgs, ... }:

{
  programs.taskwarrior = {
    enable = true;
    colorTheme = "dark-gray-blue-256";
    config = {
      verbose = 1;
      alias = {
        "@" = "context";
      };
      report = {
        next = {
          filter = "+READY limit:20";
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
        key = "$HOME/Documents/Demeter/Computer/Taskwarrior/tasks@bitsonthemind.com.key.pem";
        certificate = "$HOME/Documents/Demeter/Computer/Taskwarrior/tasks@bitsonthemind.com.cert.pem";
        ca = "$HOME/Documents/Demeter/Computer/Taskwarrior/tasks@bitsonthemind.com.root-cert.pem";
      };
    };
    # TODO: This is a secret that I could manage with nix if I figure out nix-sops
    extraConfig = ''
    include $HOME/Documents/Demeter/Computer/Taskwarrior/credentials
    '';
  };

  services.taskwarrior-sync = {
    enable = true;
    frequency = "*:0/15";
  };
}
