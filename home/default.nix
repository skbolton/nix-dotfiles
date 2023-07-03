{ config, pkgs, ... }: 

{
  imports = [
   ./git.nix
   ./gpg.nix
   ./shell.nix
   ./terminal.nix
   ./passwords.nix
   ./editor
   ./tmux
   ./desktop
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

