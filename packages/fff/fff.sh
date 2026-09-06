QUOTE=false
if [[ "${1:-}" == --quote ]]; then
  QUOTE=true
  shift
fi

FD_ALL="fd --color=always --hidden --exclude .git"
FD="$FD_ALL --type file"
INITIAL_QUERY="${*:-}"

STATE_DIR="$(mktemp -d "${TMPDIR:-/tmp}/fff.XXXXXX")"
trap 'rm -rf "$STATE_DIR"' EXIT
printf 'files\n' > "$STATE_DIR/type"
: > "$STATE_DIR/root"

cat > "$STATE_DIR/prompt" <<EOF
#!/usr/bin/env sh
case "\$1" in
  ctrl-a) printf 'all\n' > "$STATE_DIR/type" ;;
  ctrl-f) printf 'files\n' > "$STATE_DIR/type" ;;
  ctrl-d) printf 'dirs\n' > "$STATE_DIR/type" ;;
  ctrl-r)
    if [ "\$(cat "$STATE_DIR/root" 2>/dev/null)" = root ]; then
      : > "$STATE_DIR/root"
    else
      printf 'root\n' > "$STATE_DIR/root"
    fi
    ;;
  ctrl-h)
    if [ "\$(cat "$STATE_DIR/root" 2>/dev/null)" = home ]; then
      : > "$STATE_DIR/root"
    else
      printf 'home\n' > "$STATE_DIR/root"
    fi
    ;;
esac
case "\$(cat "$STATE_DIR/type")" in
  all) printf 'ﬁ ' ;;
  dirs) printf ' ' ;;
  *) printf ' ' ;;
esac
case "\$(cat "$STATE_DIR/root" 2>/dev/null)" in
  root) printf ' ' ;;
  home) printf ' ' ;;
esac
EOF

cat > "$STATE_DIR/reload" <<EOF
#!/usr/bin/env sh
pattern='.'
path=''
excludes=''
current="\$(cat "$STATE_DIR/root" 2>/dev/null)"
if [ "\$current" = root ]; then
  path='/'
  excludes='-E proc -E sys -E dev -E run'
elif [ "\$current" = home ]; then
  path="\$HOME"
fi
case "\$(cat "$STATE_DIR/type")" in
  all)  type_flag='' ;;
  dirs) type_flag='--type directory' ;;
  *)    type_flag='--type file' ;;
esac
$FD_ALL \$type_flag "\$pattern" \$path \$excludes 2>/dev/null || true
exit 0
EOF
chmod +x "$STATE_DIR/prompt" "$STATE_DIR/reload"

out=$($FD | fzf-tmux -p 90% --ansi --query "$INITIAL_QUERY" \
  --multi \
  --bind "ctrl-a:transform-prompt($STATE_DIR/prompt ctrl-a)+reload($STATE_DIR/reload)" \
  --bind "ctrl-f:transform-prompt($STATE_DIR/prompt ctrl-f)+reload($STATE_DIR/reload)" \
  --bind "ctrl-d:transform-prompt($STATE_DIR/prompt ctrl-d)+reload($STATE_DIR/reload)" \
  --bind "ctrl-r:transform-prompt($STATE_DIR/prompt ctrl-r)+reload($STATE_DIR/reload)" \
  --bind "ctrl-h:transform-prompt($STATE_DIR/prompt ctrl-h)+reload($STATE_DIR/reload)" \
  --bind "ctrl-k:preview-half-page-up" \
  --bind "ctrl-j:preview-half-page-down" \
  --prompt ' ' \
  --pointer ' ' \
  --header '| CTRL-A ﬁ | CTRL-D  | CTRL-F  | CTRL-R  | CTRL-H  |' \
  --preview 'if [ -d {} ]; then eza --tree --icons --level 3 --git-ignore --color=always {}; elif [ -f {} ]; then bat --color=always --style=grid,numbers {}; else eza --long --icons --color=always {}; fi' \
  --preview-window 'right,60%')

if [[ -n $out ]]; then
  if $QUOTE; then
    quoted=$(while IFS= read -r sel; do printf '%q ' "$sel"; done <<< "$out")
    printf '%s' "${quoted% }"
  else
    printf '%s\n' "$out"
  fi
fi
