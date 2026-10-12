{
  writeShellApplication,
  fzf,
  eza,
  unstable,
  pkgs,
  inputs,
  ...
}:

writeShellApplication {
  name = "gft.sh";
  runtimeInputs = [
    fzf
    eza
    unstable.smug
    inputs.graft.packages.${pkgs.stdenv.hostPlatform.system}.graft
  ];
  text = builtins.readFile ./gft.sh;
}
