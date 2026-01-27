{ writeShellApplication
, fd
, ripgrep
, fzf
, eza
, unstable
}:

writeShellApplication {
  name = "rally.sh";
  runtimeInputs = [ fd ripgrep fzf eza unstable.smug ];
  text = builtins.readFile ./rally.sh;
} 
