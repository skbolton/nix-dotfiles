{ makeDesktopItem, ... }:

makeDesktopItem {
  name = "Kitty - Weasel";
  desktopName = "weasel";
  icon = ./kitty-light.png;
  exec = "kitty --config /home/orlando/.config/kitty/kitty-light.conf";
  terminal = false;
}
