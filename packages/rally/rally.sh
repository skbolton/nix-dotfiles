usage() {
  cat <<EOF
Usage: rally.sh <command>

The tmux session manager and launcher she told you not to worry about.

Commands:
  list      List all tmux sessions and rallypoints
  pick      Interactively pick a session or rallypoint via fzf
  preview   Show a preview of the selected item
  select    Directly select and open a session or rallypoint

Environment Variables:
  RALLYPOINTS  Colon-separated parent paths. First-level children of these directories are listed as rallypoints.
               Example: RALLYPOINTS="~/code:~/work"

Options:
  --help  Show this help message
EOF
}

TMUX_ICON=" "
TMUX_COLOR="32"
RALLYPOINT_ICON=" "
RALLYPOINT_COLOR="34"

_tmux_sessions() {
  if tmux ls &> /dev/null; then
    while IFS= read -r session; do
      printf "\033[${TMUX_COLOR}m${TMUX_ICON}\033[0m::%s\n" "$session"
    done < <(tmux list-sessions -F '#S' 2> /dev/null)
  fi
}

_rallypoints() {
  for search_path in $(tr ":" " " <<< "$RALLYPOINTS"); do
    while IFS= read -r dir; do
      printf "\033[${RALLYPOINT_COLOR}m${RALLYPOINT_ICON}\033[0m::%s\n" "$dir"
    done < <(fd -t d -d 1 --search-path "$search_path")
  done
}

cmd_list() {
  _tmux_sessions
  _rallypoints
}

cmd_preview() {
  local follow=false
  while [[ "$1" == "--follow" ]]; do
    follow=true
    shift
  done
  local selection="$1"
  selection="${selection#\'}"
  selection="${selection%\'}"
  local item="${selection##*::}"

  if grep -q "$RALLYPOINT_ICON" <<< "$selection"; then
    eza --tree --icons --level 3 --git-ignore "$item"
  else
    if $follow; then
      while true; do
        tmux capture-pane -p -t "$item" 2>/dev/null
        printf "\033[2J"
        sleep 0.25
      done
    else
      tmux capture-pane -ep -t "$item" 2> /dev/null
      tmux capture-pane -t "#{$item}.#{last_pane_id}" -p
    fi
  fi
}

cmd_pick() {
  local selected
  selected=$(rally.sh list | fzf --delimiter '::' --with-nth '{1} {2}' \
    --input-label="<CR>  <C-e>  <C-f>  " \
    --prompt="󰇂  " \
    --input-border=none \
    --preview-border=sharp \
    --preview='rally.sh preview --follow {}' \
    --preview-window 'up:follow,60%' \
    --bind="ctrl-e:execute(nnn {2})" \
    --bind="ctrl-f:reload(fd -t d {q} ~/)" \
    --tiebreak="end")
  [[ -n "$selected" ]] && cmd_select "$selected"
}

cmd_select() {
  local selection="$1"
  # remove possible surrounding single quotes around "$1"
  # fzf adds them to their preview command
  # and other pickers might follow suit
  # doing this for compatibility to support several pickers
  # without forcing use of `{r}` in tmux.
  # TODO: Break out to helper?
  selection="${selection#\'}"
  selection="${selection%\'}"
  local item="${selection##*::}"

  if grep -q "$RALLYPOINT_ICON" <<< "$selection"; then
    _open_path "$item"
  else
    _open_tmux "$item"
  fi
}

_open_tmux() {
  local session="$1"
  if [[ -n "${TMUX:-}" ]]; then
    tmux switch -t "$session"
  else
    tmux attach-session -t "$session"
  fi
}

_open_path() {
  local path="$1"
  local dir
  local parent
  dir=$(basename "$path")
  parent=$(basename "$(dirname "$path")")

  # check for presence of git worktree at location
  if (($(git -C "$path" worktree list -v 2>/dev/null | wc -l) > 1)); then

    if [[ -f "$HOME/.config/smug/$parent.yml" ]]; then
      smug start "$parent" branch="$dir" -a
    else
      smug start default name="$parent/$dir" root="$path" branch="$dir" -a
    fi
  else
    if [[ -f "$HOME/.config/smug/$dir.yml" ]]; then
      smug start "$dir" -a
    else
      smug start default name="$dir" root="$path" -a
    fi
  fi
}

case "${1:-}" in
  --help)
    usage
    exit 0
    ;;
  list)
    cmd_list
    ;;
  preview)
    shift
    cmd_preview "$@"
    ;;
  pick)
    cmd_pick
    ;;
  select)
    shift
    cmd_select "$@"
    ;;
  "")
    usage
    exit 1
    ;;
  *)
    echo "Unknown command: $1"
    usage
    exit 1
    ;;
esac

