{ pkgs, self, ... }:

{
  services.nix-daemon.enable = true;

  nix.package = pkgs.nix;
  nix.settings.experimental-features = "nix-command flakes";

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnsupportedSystems = true;
    };
    hostPlatform = "aarch64-darwin";
  };

  networking.hostName = "dk";

  programs.zsh.enable = true;

  users.users."s.bolton" = {
    home = "/Users/s.bolton";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOsUvi/j/2Gs8QkZ5S0/bGsK/BhmU8n24eDFCc7GZx9 cardno:13_494_293"
    ];
  };

  programs.gnupg = {
    agent.enable = true;
    agent.enableSSHSupport = true;
  };

  # system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 5;
}
