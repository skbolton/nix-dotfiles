{ pkgs, inputs, ... }:

{
  nix.package = pkgs.nix;
  nix.settings.experimental-features = "nix-command flakes";
  nix.settings.trusted-users = [ "s.bolton" ];
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  nixpkgs = {
    config = {
      allowUnfree = true;
      allowUnsupportedSystems = true;
    };
    hostPlatform = "aarch64-darwin";
  };

  system.primaryUser = "s.bolton";

  networking.hostName = "niobe";

  programs.zsh.enable = true;

  users.users."s.bolton" = {
    home = "/Users/s.bolton";
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOsUvi/j/2Gs8QkZ5S0/bGsK/BhmU8n24eDFCc7GZx9 cardno:13_494_293"
    ];
  };

  stylix.enable = true;
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";

  programs.gnupg = {
    agent.enable = true;
    agent.enableSSHSupport = true;
  };

  documentation.enable = true;
  documentation.man.enable = true;

  nix-homebrew = {
    # Install Homebrew under the default prefix
    enable = true;

    # Apple Silicon Only: Also install Homebrew under the default Intel prefix for Rosetta 2
    enableRosetta = true;

    # User owning the Homebrew prefix
    user = "s.bolton";

    # Optional: Enable fully-declarative tap management
    #
    # With mutableTaps disabled, taps can no longer be added imperatively with `brew tap`.
    mutableTaps = true;
    autoMigrate = true;
  };

  # system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 5;
}
