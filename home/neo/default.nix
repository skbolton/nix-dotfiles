{ inputs, config, pkgs, ... }: 

{
  imports = [
    inputs.hyprland.homeManagerModules.default
   ../capabilities/git.nix
   ../capabilities/gpg.nix
   ../capabilities/shell.nix
   ../capabilities/terminal.nix
   ../capabilities/passwords.nix
   ../capabilities/editor
   ../capabilities/tmux
   ../capabilities/desktop
   ./pam.nix
    ../capabilities/notes
  ];

  fonts.fontconfig.enable = true;

  home = {
    username = "orlando";
    homeDirectory = "/home/orlando";
    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    stateVersion = "23.05";
    packages = with pkgs; [
      docker-compose
    ];
  };

  programs.home-manager.enable = true;
  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";
}

