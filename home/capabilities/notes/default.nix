{ pkgs, ... }:

{
  home.packages = with pkgs; [
    synology-drive-client
    logseq 
    obsidian
    zk
  ];

  xdg.configFile."zk/config.toml".source = ./zk.toml;
}
