{ pkgs, ... }:

{
  programs.home-manager.enable = true;

  home.packages = with pkgs; [ docker-compose zk rancher docker-credential-helpers ];

  delta = {
    gpg = {
      enable = true;
      autostart = true;
    };
    zsh.enable = true;
    cli_apps.enable = true;
    tmux.enable = true;
    neovim.enable = true;
    kitty.enable = true;
    terminal_theme.embark.enable = true;
    desktop.macos.aerospace.enable = true;
    lang = {
      elixir.enable = true;
      lua.enable = true;
      nix.enable = true;
    };
  };

  programs.zsh.shellAliases.rebuild = "darwin-rebuild switch --flake ~/nix-dotfiles";

  programs.ssh = {
    enable = true;
  };

  # Just until release 24.05
  home.file.".gnupg/gpg-agent.conf".text = ''
    ttyname $GPG_TTY
    enable-ssh-support
    default-cache-ttl 60
    max-cache-ttl 120
    pinentry-program ${pkgs.pinentry_mac}/bin/pinentry-mac
  '';

  home.file.".gnupg/sshcontrol".text = ''
    B189B794F1B984F63BAFA6785F3B2EE2F3458934
  '';
  home.stateVersion = "24.05";
}
