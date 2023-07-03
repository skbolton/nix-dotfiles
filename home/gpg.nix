{ config, ... }: 

{

  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gpg";
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
    enableZshIntegration = true;
    pinentryFlavor = "gtk2";
    defaultCacheTtl = 60;
    maxCacheTtl = 120;
    enableScDaemon = true;
    grabKeyboardAndMouse = false;
    sshKeys = [
      "B189B794F1B984F63BAFA6785F3B2EE2F3458934"
    ];
  };
}


