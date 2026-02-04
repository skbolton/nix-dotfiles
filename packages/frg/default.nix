{ writeShellApplication, ripgrep, bat, fzf }:

writeShellApplication {
  name = "frg";
  runtimeInputs = [ ripgrep bat fzf ];
  text = builtins.readFile ./frg.sh;
}
