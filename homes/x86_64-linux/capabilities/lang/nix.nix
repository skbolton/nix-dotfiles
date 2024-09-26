{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nil
    nixpkgs-fmt
  ];
}
