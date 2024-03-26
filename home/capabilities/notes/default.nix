{ pkgs, ... }:

{
  home.sessionVariables = {
    JOURNALS = "$HOME/Documents/Logbook";
    ZK_NOTEBOOK_DIR = "$HOME/Documents/Reference";
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
