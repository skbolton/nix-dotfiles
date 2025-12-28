{ pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.packages = with pkgs; [ docker-compose zk rancher docker-credential-helpers raycast ];

  delta = {
    ai.enable = true;
    sops.enable = true;
    gpg = {
      enable = true;
      autostart = true;
      pinentry = pkgs.pinentry_mac;
      enableExtraSocket = false;
    };
    zsh.enable = true;
    cli_apps.enable = true;
    tmux.enable = true;
    neovim.enable = true;
    kitty.enable = true;
    notes = {
      enable = true;
      notebook_dir = "$HOME/Documents/Notes";
    };
    timetracking = {
      enable = true;
    };
    tasks = {
      enable = true;
      sync = false;
    };
    theme.enable = true;
    theme.palette = "inspired";
    desktop.macos.aerospace.enable = false;
    cloud.gcloud.enable = true;
    lang = {
      elixir.enable = true;
      lua.enable = true;
      nix.enable = true;
    };
  };

  programs.zsh.shellAliases = {
    dk = "task";
    sup = "task add proj:Admin.Meetings.Standup sched:today Standup";
    grm = "task add proj:Admin.Meetings.Grooming sched:today Product Grooming";
    spln = "task add proj:Admin.Meetings.SprintPlanning sched:today Sprint Planning";
    tpln = "task add proj:Admin.Meetings.TechPlanning sched:today Tech Planning";
    rtr = "task add proj:Admin.Meetings.Retro sched:today Retro";
    ooo = "task add proj:Admin.Meetings.1on1 sched:today";
  };

  programs.man.enable = true;

  programs.zsh.shellAliases.rebuild = "sudo darwin-rebuild switch --flake \"$HOME/nix-dotfiles#niobe\"";

  programs.ssh = {
    enable = true;
    enableDefaultConfig = false;
  };

  home = {
    username = "s.bolton";
    homeDirectory = "/Users/s.bolton";
    stateVersion = "24.05";
  };
}
