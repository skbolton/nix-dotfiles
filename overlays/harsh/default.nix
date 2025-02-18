{ channels, ... }:

final: prev: {
  inherit (channels.unstable) harsh;
}
