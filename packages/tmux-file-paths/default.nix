{ writeShellApplication
, fzf
, ripgrep
, bat
}:

writeShellApplication
{
  name = "tmux-file-paths";
  runtimeInputs = [ fzf ripgrep bat ];
  text = ''
    POSITIONAL_ARGS=()
    PREVIEWER="print"

    # Procuss arguments
    while [[ $# -gt 0 ]]; do
      case $1 in
        -f|--fuzzy)
        PREVIEWER="fuzzy"
        shift
        ;;
        -*)
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

    preview() {
      if [[ $PREVIEWER = "fuzzy" ]]; then
        fzf --delimiter ':' --preview 'bat {1} --color=always --highlight-line {2} --line-range {2}:'
      else
        xargs -0 echo
      fi
    }

    for id in $(tmux list-panes -s -F '#D'); do
      tmux capture -p -t "$id"
    done | rg --no-line-number --only-matching '(([.\w\\-~\$@]+)?(/[.\w\-@]+)+\.\w+/?(:\d+))' \
      | sort -u \
      | rg --color=never --null "$ADDITIONAL_FILTER" \
      | preview
  '';
}
