{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # TODO: Figure out how to make this part of the hook
    # This isn't very nixy
    python3
    timewarrior
  ];

  programs.taskwarrior = {
    enable = true;
    colorTheme = "dark-violets-256";
    config = {
      alias = {
        "@" = "context";
      };
      urgency = {
        project.coefficient = 0;
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

  xdg.dataFile."task/hooks/on-modify.timewarrior" = {
    source = "${pkgs.timewarrior}/share/doc/timew/ext/on-modify.timewarrior";
    executable = true;
  };

  services.taskwarrior-sync = {
    enable = true;
    frequency = "*:0/15";
  };
}
