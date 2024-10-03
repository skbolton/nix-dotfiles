{ writeShellScriptBin
, fzf
, ripgrep
, bat
}:

writeShellScriptBin "tmux-file-paths" ''
  pane_file=$HOME/.cache/tmux-find-file-paths
  truncate -s 0 $pane_file

  for id in $(tmux list-panes -s -F '#D'); do
    tmux capture -p -t $id >> $pane_file
  done

  results=$(${ripgrep}/bin/rg --color=never --only-matching '(([.\w\\-~\$@]+)?(/[.\w\-@]+)+\.\w+/?(:\d+))' $pane_file)

  if [[ $1 == "-f" ]]; then
    ${ripgrep}/bin/rg --no-line-number --color=never --only-matching '(([.\w\\-~\$@]+)?(/[.\w\-@]+)+\.\w+/?(:\d+))' $pane_file | sort -u | ${fzf}/bin/fzf --delimiter ':' --preview '${bat}/bin/bat {1} --color=always --highlight-line {2} --line-range {2}:'
  else
    ${ripgrep}/bin/rg --no-line-number --color=never --only-matching '(([.\w\\-~\$@]+)?(/[.\w\-@]+)+\.\w+/?(:\d+))' $pane_file | sort -u
  fi
''

