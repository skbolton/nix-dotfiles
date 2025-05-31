{ writeShellApplication
, fd
, ripgrep
, fzf
, eza
, smug
}:

writeShellApplication {
  name = "rally.sh";
  runtimeInputs = [ fd ripgrep fzf eza smug ];
  text = ''
    _tmux_sessions() {
      tmux list-sessions -F '#S' 2> /dev/null | awk '{print "\033[32m \033[0m" $0}'| rg -v "$(tmux display -p '#S')"
    }

    _rallypoints() {
      for search_path in $(tr ":" " " <<< "$HOME:$HOME/Public:$HOME/.local/share:$HOME/.config"); do
        fd -t d -d 1 --search-path "$search_path" | awk '{print "\033[34m \033[0m" $0}'
      done
    }

    _select() {
    # TODO: Find a better way to write preview
      fzf --accept-nth '{2}' \
        --header="<CR>: 🏗️ | C-e: 📁 | C-f: 🏠" \
        --prompt="  " \
        --preview 'tmux capture-pane -ep -t {2} 2> /dev/null || eza --tree --icons --level 3 --git-ignore {2}' \
        --bind="ctrl-e:execute(nnn {2})" \
        --bind="ctrl-f:reload(fd -t d {q} ~/)"
    }

    # TODO: Find a better way to write preview
    TARGET=$( (_tmux_sessions; _rallypoints ) | _select)
    NAME=$(basename "$TARGET")

    if [[ -f "$TARGET/.steve-smug.yml" ]]; then
      smug start -f "$TARGET/.steve-smug.yml" -a
    elif [[ -f "$HOME/.config/smug/$NAME.yml" ]]; then
      smug start "$NAME" -a
    else
      smug start default name="$NAME" root="$TARGET" -a
    fi
  '';
} 
