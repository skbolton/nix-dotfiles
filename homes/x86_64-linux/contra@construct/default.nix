{ pkgs, ... }:

{
  fonts.fontconfig.enable = true;

  delta = {
    ai.enable = true;
    sops.enable = true;
    gpg = {
      enable = true;
      autostart = false;
      enableExtraSocket = false;
    };
    zsh.enable = true;
    cli_apps.enable = true;
    tmux.enable = true;
    neovim.enable = true;
    theme = {
      enable = true;
      palette = "dev-null";
    };
    kitty.enable = true;
    lang = {
      elixir.enable = true;
      nodejs.enable = true;
      lua.enable = true;
      nix.enable = true;
      json.enable = true;
    };
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

  programs.zsh.shellAliases.rebuild = "sudo nixos-rebuild switch";

  programs.man.generateCaches = true;

  home = {
    username = "contra";
    homeDirectory = "/home/contra";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    packages = with pkgs; [
      docker-compose
      firefox
    ];
  };

  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

