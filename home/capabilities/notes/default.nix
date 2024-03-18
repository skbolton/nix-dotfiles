{ pkgs, ... }:

{
  home.sessionVariables = {
    JOURNALS = "$HOME/00-09-System/02-Logs";
    ZK_NOTEBOOK_DIR = "$HOME/00-09-System/02-Logs/";
  };

  home.packages = with pkgs; [
    synology-drive-client
    logseq
    obsidian
    zk
    (import ./note-search.nix { inherit pkgs; })
  ];

  xdg.configFile."zk/config.toml".source = ./zk.toml;
}
