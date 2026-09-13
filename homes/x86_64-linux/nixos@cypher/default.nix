{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  delta = {
    zsh.enable = true;
    cli_apps.enable = true;
    tmux.enable = true;
    gpg = {
      enable = true;
      autostart = false;
      enableExtraSocket = true;
    };
    neovim.enable = true;
    notes = {
      enable = true;
      notebook_dir = "$HOME/Documents/Notes";
    };
    theme = {
      enable = true;
      palette = "dev-null";
    };
    kitty.enable = true;
  };

  # home manage enable ssh support always starts the gpg agent
  # which doesn't work for passthrough
  delta.gpg.enableSshSupport = false;
  services.gpg-agent.extraConfig = ''
    enable-ssh-support
  '';
  home.sessionVariablesExtra = ''
    unset SSH_AGENT_PID
    export SSH_AUTH_SOCK="$(gpgconf --list-dirs agent-ssh-socket)"
  '';

  programs.man.generateCaches = true;

  home = {
    username = "nixos";
    homeDirectory = "/home/nixos";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    packages = [ ];
  };

  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}
