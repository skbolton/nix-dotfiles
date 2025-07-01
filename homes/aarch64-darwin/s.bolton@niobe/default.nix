{ pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.packages = with pkgs; [ docker-compose zk rancher docker-credential-helpers ];

  delta = {
    ai.enable = true;
    gpg = {
      enable = true;
      autostart = false;
      pinentry = pkgs.pinentry_mac;
    };
    zsh.enable = true;
    cli_apps.enable = true;
    tmux = {
      enable = true;
      extraConfig = ''
        run -b 'smug start notes'
      '';
    };
    neovim.enable = true;
    kitty.enable = true;
    notes = {
      enable = true;
      notebook_dir = "$HOME/Documents/Notes";
    };
    timetracking = {
      enable = true;
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

  programs.man.enable = true;

  programs.zsh.shellAliases.rebuild = "sudo darwin-rebuild switch --flake \"$HOME/nix-dotfiles#niobe\"";

  programs.ssh = {
    enable = true;
  };

  home.stateVersion = "24.05";
}
