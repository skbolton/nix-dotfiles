{ ... }:

{
  sops = {
    defaultSopsFile = ../../../secrets/nixos/secrets.yaml;
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    secrets.orlando-password = {
      neededForUsers = true;
    };
    secrets.contra-password = {
      neededForUsers = true;
    };
    secrets.smb-creds = { };
    secrets.builder-ssh-key = {
      neededForUsers = true;
      path = "/root/.ssh/builder_ed25519";
    };
  };
}
