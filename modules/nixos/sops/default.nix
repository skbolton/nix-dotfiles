{ ... }:

{
  sops = {
    defaultSopsFile = ../../../secrets/system-secrets.yaml;
    validateSopsFiles = false;

    age = {
      sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
      keyFile = "/var/lib/sops-nix/key.txt";
      generateKey = true;
    };

    secrets.orlando-password = { neededForUsers = true; };
    secrets.beevey-password = { neededForUsers = true; };
    secrets.mouse-password = { neededForUsers = true; };
    secrets.cloudflared-tunnel-creds = { };
  };
}
