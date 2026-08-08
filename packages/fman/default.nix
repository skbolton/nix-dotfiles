{
  writeShellApplication,
  fzf,
}:

writeShellApplication {
  name = "fman";
  runtimeInputs = [ fzf ];
  text = ''
    man -k . \
      | fzf --prompt='  ' \
            --tiebreak=begin \
      | awk '{print $1}' \
      | xargs -r man
  '';
}
