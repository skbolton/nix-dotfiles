{ config, ... }: 

{

  programs.gpg = {
    enable = true;
    publicKeys = [
      { 
        source = "/etc/nixos/my-key.asc";
        trust = 5;
      }
    ];
    settings = {
      throw-keyids = true;
    };
  };

  services.gpg-agent = {
    enable = true;
    verbose = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    enableZshIntegration = true;
    pinentryFlavor = "gnome3";
    defaultCacheTtl = 60;
    maxCacheTtl = 120;
    enableScDaemon = true;
    grabKeyboardAndMouse = false;
    sshKeys = [
      "B189B794F1B984F63BAFA6785F3B2EE2F3458934"
    ];
  };

  programs.ssh = {
    enable = true;

    matchBlocks = {
      openssh_win32 = {
        hostname = "172.16.90.200";
        user = "adminarsenal/stephen.bolton";
      };

      arch_wsl = {
        proxyJump = "openssh_win32";
        hostname = "localhost";
        user = "orlando";
        port = 2222;
        localForwards = [
          {
            # bind is the local 
            bind.port = 4000;
            # host is the remote
            host.address = "localhost";
            host.port = 4000;
          }
          {
            bind.port = 54321;
            host.address = "localhost";
            host.port = 54321;
          }
        ];
        remoteForwards = [
          {
            # host is the local client it this situation
            host.address = "/run/user/1000/gnupg/S.gpg-agent.extra";
            # bind is the remote
            bind.address = "/run/user/1000/gnupg/d.7scgtn5j3mmef4u1zfkxpb9z/S.gpg-agent";
          }
          {
            host.address = "/run/user/1000/gnupg/S.gpg-agent.ssh";
            bind.address = "/run/user/1000/gnupg/d.7scgtn5j3mmef4u1zfkxpb9z/S.gpg-agent.ssh";
          }
        ];
      };
    };
  };
}

