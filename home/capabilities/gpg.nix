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
}


