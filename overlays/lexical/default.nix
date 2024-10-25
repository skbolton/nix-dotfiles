{ channels, ... }:

final: prev: {
  inherit (channels.unstable) lexical;
}
