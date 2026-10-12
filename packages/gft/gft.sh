usage() {
  cat <<'EOF'
Usage: gft <command>

Stem-aware tmux launcher, companion to rally.

Commands:
  list      List live tmux sessions and dormant graft stems
  pick      Interactively pick a session or stem via fzf
  preview   Show a preview of the selected item
  select    Directly select and open a session or stem
  create    Create the tmux session for a stem, detached. Switches to it
            when run inside tmux, otherwise prints the session name.
            Intended for graft's postcreate hook: gft create "$GRAFT_PATH"

Stem sessions are built from ~/.config/smug/<collection>.yml when the
stem's manifest names a collection with a matching template. Such sessions
are named <collection>/<stem>. The template receives the variables stem
(the full session name), branch, and root (absolute stem path), e.g.:

    session: ${stem}
    root: ${root}
    windows:
      - name: "api"
        root: ${root}/api
        commands:
          - nvim

A stem containing a single repo is launched like a plain project instead:
~/.config/smug/<repo>.yml if it exists, else the default template, with
the session rooted at the repo's worktree. Those templates receive name
(session name), branch, and root (worktree path). Without any matching
template, multi-repo stems get a generated session: one window at the
stem root plus one window per member repo, each cd'ed into its worktree.
EOF
}

TMUX_ICON=" "
TMUX_COLOR="32"
STEM_ICON="󰙅 "
STEM_COLOR="34"

_live_sessions() {
  tmux list-sessions -F '#S' 2> /dev/null || true
}

_session_name() {
  local name
  name=$(basename "$1")
  tr '.:' '-' <<< "$name"
}

_stem_collection() {
  sed -n 's/^collection = "\(.*\)"/\1/p' "$1/.graft/manifest.toml"
}

# Stems launched from a collection template are named <collection>/<stem>;
# everything else keeps the plain stem name.
_stem_session_name() {
  local stem_path="$1" session="$2"
  local collection
  collection=$(_stem_collection "$stem_path")
  if [[ -n "$collection" && -f "$HOME/.config/smug/$collection.yml" ]]; then
    printf "%s/%s\n" "$collection" "$session"
  else
    printf "%s\n" "$session"
  fi
}

_tmux_sessions() {
  if tmux ls &> /dev/null; then
    while IFS= read -r session; do
      printf "\033[${TMUX_COLOR}m${TMUX_ICON}\033[0m::%s\n" "$session"
    done < <(_live_sessions)
  fi
}

_stems() {
  local live
  live=$(_live_sessions)
  while IFS=$'\t' read -r rtype name path; do
    if [[ "$rtype" != "stem" ]]; then
      continue
    fi
    if grep -Fxq "$(_stem_session_name "$path" "$(_session_name "$name")")" <<< "$live"; then
      continue
    fi
    printf "\033[${STEM_COLOR}m${STEM_ICON}\033[0m::%s::%s\n" "$name" "$path"
  done < <(graft list --porcelain 2> /dev/null)
}

cmd_list() {
  _tmux_sessions
  _stems
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

  if grep -q "$STEM_ICON" <<< "$selection"; then
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

_open_tmux() {
  local session="$1"
  if [[ -n "${TMUX:-}" ]]; then
    tmux switch-client -t "=$session"
  else
    tmux attach-session -t "=$session"
  fi
}

_build_session() {
  local stem_path="$1" session="$2"
  local stem_name branch
  stem_name=$(basename "$stem_path")
  branch=$(sed -n 's/^branch = "\(.*\)"/\1/p' "$stem_path/.graft/manifest.toml")

  local -a repos=()
  local rtype name repo repo_path
  while IFS=$'\t' read -r rtype name repo repo_path; do
    if [[ "$rtype" == "repo" && "$name" == "$stem_name" ]]; then
      repos+=("$repo"$'\t'"$repo_path")
    fi
  done < <(graft list --porcelain 2> /dev/null)

  if (( ${#repos[@]} == 1 )); then
    repo="${repos[0]%$'\t'*}"
    repo_path="${repos[0]#*$'\t'}"
    if [[ -f "$HOME/.config/smug/$repo.yml" ]]; then
      smug start "$repo" name="$session" branch="$branch" root="$repo_path" --detach
    else
      smug start default name="$session" branch="$branch" root="$repo_path" --detach
    fi
    return
  fi

  local collection
  collection=$(_stem_collection "$stem_path")
  if [[ -n "$collection" && -f "$HOME/.config/smug/$collection.yml" ]]; then
    smug start "$collection" stem="$collection/$session" branch="$branch" root="$stem_path" --detach
  else
    _build_default_session "$stem_path" "$session"
  fi
}

_build_default_session() {
  local stem_path="$1" session="$2"
  local stem_name
  stem_name=$(basename "$stem_path")

  tmux new-session -d -s "$session" -c "$stem_path" -n "$stem_name"
  while IFS=$'\t' read -r rtype name repo repo_path; do
    if [[ "$rtype" == "repo" && "$name" == "$stem_name" ]]; then
      tmux new-window -t "$session:" -n "$repo" -c "$repo_path"
    fi
  done < <(graft list --porcelain 2> /dev/null)
}

cmd_create() {
  local stem_path="$1"
  if [[ ! -d "$stem_path" ]]; then
    printf "not a stem directory: %s\n" "$stem_path" >&2
    exit 1
  fi

  local session
  session=$(_session_name "$stem_path")
  local full
  full=$(_stem_session_name "$stem_path" "$session")
  if ! tmux has-session -t "=$full" 2> /dev/null; then
    _build_session "$stem_path" "$session"
  fi

  if [[ -n "${TMUX:-}" ]]; then
    tmux switch-client -t "=$full"
  else
    printf "%s\n" "$full"
  fi
}

cmd_select() {
  local selection="$1"
  selection="${selection#\'}"
  selection="${selection%\'}"
  local item="${selection##*::}"

  if grep -q "$STEM_ICON" <<< "$selection"; then
    local session full
    session=$(_session_name "$item")
    full=$(_stem_session_name "$item" "$session")
    if ! tmux has-session -t "=$full" 2> /dev/null; then
      _build_session "$item" "$session"
    fi
    _open_tmux "$full"
  else
    _open_tmux "$item"
  fi
}

cmd_pick() {
  local selected
  selected=$("$0" list | fzf --delimiter '::' --with-nth '{1} {2}' \
    --input-label="<CR> " \
    --prompt="󰇂  " \
    --input-border=none \
    --preview-border=sharp \
    --preview="$0 preview --follow {}" \
    --preview-window 'right:follow,60%' \
    --tiebreak="end")
  [[ -n "$selected" ]] && cmd_select "$selected"
}

case "${1:-}" in
  --help)
    usage
    exit 0
    ;;
  list)
    cmd_list
    ;;
  pick)
    cmd_pick
    ;;
  preview)
    shift
    cmd_preview "$@"
    ;;
  select)
    shift
    cmd_select "$@"
    ;;
  create)
    shift
    cmd_create "$@"
    ;;
  "")
    usage
    exit 1
    ;;
  *)
    printf "Unknown command: %s\n" "$1" >&2
    usage
    exit 1
    ;;
esac
