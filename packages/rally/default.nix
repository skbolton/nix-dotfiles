{ writeShellApplication
, fd
, fzf
, eza
, smug
}:

writeShellApplication {
  name = "rally.sh";
  runtimeInputs = [ fd fzf eza smug ];
  text = ''
    _targets() {
      { fd -t d -d 1 '.' "$HOME/Public" & fd -t d -d 1 '.' "$HOME"; }
    }

    _select() {
      fzf --header-first \
        --header="Launch Project" \
        --prompt="󰑣 " \
        --preview 'eza --tree --icons --level 3 --git-ignore {}' \
        --delimiter '/' \
        --with-nth '-3..-1'
    }

    TARGET=$(_targets | _select)
    NAME=$(basename "$TARGET")


    if [[ -f "$TARGET/.steve-smug.yml" ]]; then
      smug start -f "$TARGET/.steve-smug.yml" -a
    elif [[ -f "$HOME/.config/smug/$NAME.yml" ]]; then
      smug start "$NAME" -a
    else
      smug start default name="$(tr '[:lower:]' '[:upper]' "$NAME")" root="$TARGET" -a
    fi
  '';
} 
