{ channels, ... }:

final: prev: {
  inherit (channels.unstable) vimPlugins aerospace harsh ollama open-webui maple-mono smug;
}
