_tmux_sessions() {
  if tmux ls &> /dev/null; then
    tmux list-sessions -F '#S' 2> /dev/null | awk '{print "\033[32m \033[0m" $0}'
  fi
}

_rallypoints() {
  for search_path in $(tr ":" " " <<< "$RALLYPOINTS"); do
    fd -t d -d 1 --search-path "$search_path" | awk '{print "\033[34m \033[0m" $0}'
  done
}

_select() {
# TODO: Find a better way to write preview
  fzf --accept-nth '{2}' \
    --input-label="<CR>  <C-e>  <C-f>  " \
    --prompt="󰇂  " \
    --input-border=none \
    --preview-border=sharp \
    --preview 'tmux capture-pane -ep -t {2} 2> /dev/null || eza --tree --icons --level 3 --git-ignore {2}' \
    --bind="ctrl-e:execute(nnn {2})" \
    --bind="ctrl-f:reload(fd -t d {q} ~/)" \
    --tiebreak="end"
}

# TODO: Find a better way to write preview
TARGET=$( (_tmux_sessions; _rallypoints ) | _select)
NAME=$(basename "$TARGET")

# check for git worktrees
if (($(git -C "$TARGET" worktree list -v 2>/dev/null | wc -l) > 1)); then
  REPO="$(basename "$(dirname "$TARGET")")"
  BRANCH="$NAME"

  if tmux has-session -t "$REPO/$BRANCH"; then
    tmux switch -t "$REPO/$BRANCH" 2> /dev/null || tmux attach -t "$REPO/$BRANCH"
  elif [[ -f "$HOME/.config/smug/$REPO.yml" ]]; then
    smug start "$REPO" branch="$BRANCH" -a
  else
    smug start default name="$REPO/$BRANCH" root="$TARGET" branch="$BRANCH" -a
  fi
else
  if tmux has-session -t "$NAME"; then
    tmux switch -t "$NAME" 2> /dev/null || tmux attach -t "$NAME"
  elif [[ -f "$HOME/.config/smug/$NAME.yml" ]]; then
    smug start "$NAME" -a
  else
    smug start default name="$NAME" root="$TARGET" -a
  fi
fi


