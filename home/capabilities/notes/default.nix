{ pkgs, ... }:

{
  home.packages = [
    pkgs.zk
  ];

  xdg.configFile."zk/config.toml".source = ./zk.toml;
}
