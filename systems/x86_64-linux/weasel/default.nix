# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
wsl = {
    enable = true;
    wslConf = {
      automount.root = "/mnt";
      network.generateHosts = false;
    };
    defaultUser = "orlando";
    startMenuLaunchers = true;
    usbip.enable = true;
    usbip.autoAttach = ["2-3"];
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  networking.hostName = "weasel";

  users.users.orlando = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ];
    initialPassword = "temp";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOsUvi/j/2Gs8QkZ5S0/bGsK/BhmU8n24eDFCc7GZx9 cardno:13_494_293"
    ];
  };

  programs.zsh.enable = true;
  delta.theme.enable = true;
  delta.theme.palette = "embark";

  services.udev.packages = [ pkgs.yubikey-personalization ];
  services.pcscd.enable = true;

 environment.systemPackages = with pkgs; [
    git
    zsh
    neovim
  ];

  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.11"; # Did you read the comment?
}
