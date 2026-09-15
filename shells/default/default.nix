{
  lib,
  inputs,
  namespace,
  pkgs,
  mkShell,
  ...
}:
mkShell {
  packages = with pkgs; [
    sops
    age
    pass
    cloudflared
  ];
}
