{ pkgs, ... }:

{
  home.sessionVariables = {
    JOURNALS = "$HOME/Life/00-09-System/02-Logs";
    ZK_NOTEBOOK_DIR = "$HOME/Life/00-09-System/02-Logs/";
  };

  home.packages = with pkgs; [
    synology-drive-client
    logseq 
    obsidian
    zk
  ];

  xdg.configFile."zk/config.toml".source = ./zk.toml;
}
