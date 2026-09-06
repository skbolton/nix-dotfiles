{
  writeShellApplication,
  fd,
  eza,
  bat,
  fzf,
}:

writeShellApplication {
  name = "fff";
  runtimeInputs = [
    fd
    eza
    bat
    fzf
  ];
  text = builtins.readFile ./fff.sh;
}
