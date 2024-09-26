{ pkgs, modulesPath, ... }:

{
  imports = [
    "${modulesPath}/installer/cd-dvd/installation-cd-minimal-new-kernel-no-zfs.nix"
  ];

  environment.systemPackages = with pkgs; [ neovim git networkmanager ];

  systemd.services.sshd.wantedBy = pkgs.lib.mkForce [ "multi-user.target" ];
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIOsUvi/j/2Gs8QkZ5S0/bGsK/BhmU8n24eDFCc7GZx9 cardno:13_494_293"
  ];
}
