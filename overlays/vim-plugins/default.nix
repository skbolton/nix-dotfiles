{ channels, ... }:

final: prev: {
  inherit (channels.unstable) vimPlugins;
}
