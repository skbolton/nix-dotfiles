{ pkgs, ... }:

{
  imports = [
  ];

  wsl = {
    enable = true;
    wslConf = {
      automount.root = "/mnt";
      network.generateHosts = false;
    };
    defaultUser = "orlando";
    startMenuLaunchers = true;
    nativeSystemd = false;
  };

  networking = {
    hostName = "weasel";
    hosts = {
      "127.0.0.1" = [ "kubernetes" ];
    };
  };

  users.users.orlando = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOsUvi/j/2Gs8QkZ5S0/bGsK/BhmU8n24eDFCc7GZx9 cardno:13_494_293"
    ];
  };

  virtualisation.docker.enable = true;
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
    (google-cloud-sdk.withExtraComponents [
      google-cloud-sdk.components.kubectl
      google-cloud-sdk.components.gke-gcloud-auth-plugin
      google-cloud-sdk.components.pubsub-emulator
    ])
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
