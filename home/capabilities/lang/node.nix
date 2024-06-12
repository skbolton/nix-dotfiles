{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nodejs_20
    nodePackages.typescript-language-server
  ];
}
