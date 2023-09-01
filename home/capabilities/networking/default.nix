{ pkgs, ...}:
{
  home.packages = with pkgs; [
    nm-applet
  ];
}
