{ pkgs, ... }:

{
  imports = [
  ];

  wsl = {
    enable = true;
    wslConf.automount.root = "/mnt";
    defaultUser = "orlando";
    startMenuLaunchers = true;
    nativeSystemd = false;

    # Enable native Docker support
    docker-native.enable = true;

    # Enable integration with Docker Desktop (needs to be installed)
    # docker-desktop.enable = true;

  };

  networking.hostName = "weasel";

  users.users.orlando = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOsUvi/j/2Gs8QkZ5S0/bGsK/BhmU8n24eDFCc7GZx9 cardno:13_494_293"
    ];
  };

  programs.zsh.enable = true;

  # Enable nix flakes
  nix.package = pkgs.nixFlakes;
  nix.extraOptions = ''
    experimental-features = nix-command flakes
  '';

  environment.systemPackages = with pkgs; [
    git
    zsh
    neovim
  ];

  services.openssh = {
    enable = true;
    ports = [ 2242 ];
    settings = {
      StreamLocalBindUnlink = true;
    };
  };

  programs.gnupg.agent.enable = false;

  system.stateVersion = "23.05";
}
