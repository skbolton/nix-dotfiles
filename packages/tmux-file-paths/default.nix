{ writeShellScriptBin
, fzf
, ripgrep
, bat
}:

writeShellScriptBin "tmux-file-paths" ''
  POSITIONAL_ARGS=()
  PREVIEWER="print"
  FILEPATHREGEX='(([.\w\\-~\$@]+)?(/[.\w\-@]+)+\.\w+/?(:\d+))'

  # Empty/create file to hold pane contents
  PANEFILE=$HOME/.cache/tmux-find-file-paths
  truncate -s 0 $PANEFILE

  # Procuss arguments
  while [[ $# -gt 0 ]]; do
    case $1 in
      -f|--fuzzy)
      PREVIEWER="fuzzy"
      # PREVIEWER="${fzf}/bin/fzf --delimiter ':' --preview '${bat}/bin/bat {1} --color=always --highlight-line {2} --line-range {2}:'"
      shift
      ;;
      -*|--*)
      echo "Unknown option $1"
      exit 1
      ;;
    *)
    POSITIONAL_ARGS+=("$1")
    shift
    esac
  done

  # restore positional parameters
  set -- "''${POSITIONAL_ARGS[@]}"

  DEFAULT_FILTER=".*"
  ADDITIONAL_FILTER="''${1:-$DEFAULT_FILTER}"

  # Capture all panes into panefile
  for id in $(tmux list-panes -s -F '#D'); do
    tmux capture -p -t $id >> $PANEFILE
  done

  preview() {
    if [[ $PREVIEWER = "fuzzy" ]]; then
      ${fzf}/bin/fzf --delimiter ':' --preview '${bat}/bin/bat {1} --color=always --highlight-line {2} --line-range {2}:'
    else
      xargs -0 echo
    fi
  }

  ${ripgrep}/bin/rg --no-line-number --only-matching $FILEPATHREGEX $PANEFILE \
    | sort -u \
    | ${ripgrep}/bin/rg --color=never --null "$ADDITIONAL_FILTER" \
    | preview
''

