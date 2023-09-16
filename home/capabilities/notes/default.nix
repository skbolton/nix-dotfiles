{ pkgs, ... }:

{
  home.packages = [
    synology-drive-client
    logseq 
    obsidian
    pkgs.zk
  ];

  xdg.configFile."zk/config.toml".source = ./zk.toml;
}
