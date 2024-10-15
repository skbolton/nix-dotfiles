{ writeShellScriptBin
, fzf
}:

writeShellScriptBin "fman" ''
  man -k . | ${fzf}/bin/fzf --prompt='  ' --tiebreak=begin | awk '{print $1}' | xargs -r man
''
