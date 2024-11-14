{ channels, ... }:

final: prev: {
  inherit (channels.unstable) aerospace;
}
