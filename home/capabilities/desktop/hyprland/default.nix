{ pkgs, inputs, ... }:

{

  imports = [
    ../waybar.nix
    ../dunst.nix
  ];

  home.packages = with pkgs; [ playerctl swaybg wl-clipboard grim slurp inputs.hyprland-contrib.packages.x86_64-linux.grimblast neofetch wofi-emoji ];

  xdg.dataFile."wallpaper/1e1c31.png".source = ../1e1c31.png;
  xdg.dataFile."wallpaper/light.png".source = ../light.JPG;

  programs.wofi.enable = true;

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = import ./config.nix {};
    xwayland.enable = true;
  };
}
