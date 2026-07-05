{ pkgs, config, ... }:

{
  fonts.fontconfig.enable = true;

  delta = {
    ai.enable = true;
    sops.enable = true;
    gpg = {
      enable = true;
      autostart = true;
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
    rally = {
      enable = true;
      rallypoints = [ "$HOME" "$HOME/c" ];
    };
    desktop.wayland.hyprland = {
      enable = true;
      autostart = [ ];
    };
    kitty.enable = true;
    lang = {
      elixir.enable = true;
      nodejs.enable = true;
      lua.enable = true;
      nix.enable = true;
      json.enable = true;
      cpp.enable = true;
    };
    desktop.wayland.waybar.enable = true;
    desktop.wayland.waybar.target = [ "hyprland-session.target" ];
    desktop.dunst.enable = true;
    desktop.nm-applet.enable = true;
  };

  programs.zsh.shellAliases.rebuild = "sudo nixos-rebuild switch --flake '${config.home.homeDirectory}/c/nix-dotfiles#trinity'";

  programs.man.generateCaches = true;

  keyboard = {
    variant = "colemak";
    options = "lv3:ralt_alt";
  };

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




