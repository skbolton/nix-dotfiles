{ pkgs, ... }:

{
  home.sessionVariables = {
    JOURNALS = "$HOME/Documents/Logbook/Journal";
    ZK_NOTEBOOK_DIR = "$HOME/Documents/Reference";
  };

  home.packages = with pkgs; [
    synology-drive-client
    logseq
    obsidian
    zk
    (import ./note-search.nix { inherit pkgs; })
    (pkgs.callPackage ./qke.nix { })
    (pkgs.callPackage ./week.nix { })
    (pkgs.callPackage ./month.nix { })
    (pkgs.callPackage ./year.nix { })
  ];

  xdg.configFile."zk/config.toml".source = ./zk.toml;
}
