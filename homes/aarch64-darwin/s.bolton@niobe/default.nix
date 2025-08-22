{ pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.packages = with pkgs; [ docker-compose zk rancher docker-credential-helpers ];

  delta = {
    ai.enable = true;
    sops.enable = true;
    gpg = {
      enable = true;
      autostart = false;
      pinentry = pkgs.pinentry_mac;
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
    terminal_theme.embark.enable = true;
    desktop.macos.aerospace.enable = true;
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
    ooo = "task add proj:Admin.Meetings.1on1 sched:today";
  };

  programs.taskwarrior.config.default.project = "Admin";
  programs.taskwarrior.config.alias.do = "add";

  programs.man.enable = true;

  programs.zsh.shellAliases.rebuild = "sudo darwin-rebuild switch --flake \"$HOME/nix-dotfiles#niobe\"";

  programs.ssh = {
    enable = true;
  };

  home = {
    username = "s.bolton";
    homeDirectory = "/Users/s.bolton";
    stateVersion = "24.05";
  };
}
