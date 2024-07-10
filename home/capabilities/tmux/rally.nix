{ writeShellScriptBin
, fzf
, eza
, smug
}:

writeShellScriptBin "rally.sh" ''
  set -eu
  TARGET=$(ls -d ~/Public/* ~/* | ${fzf}/bin/fzf --header-first --header="Launch Project" --prompt="🔮 " --preview '${eza}/bin/eza --tree --icons --level 3 --git-ignore {}' --delimiter '/' --with-nth -2..-1)
  NAME=$(basename $TARGET)
  SESSION_NAME=$(echo $NAME | tr [:lower:] [:upper:])

  if [[ -f "$TARGET/.steve-smug.yml" ]]; then
    ${smug}/bin/smug start -f "$TARGET/.steve-smug.yml" -a
  elif [[ -f "$HOME/.config/smug/$NAME.yml" ]]; then
    ${smug}/bin/smug start $NAME -a
  else
    ${smug}/bin/smug start default name=$SESSION_NAME root=$TARGET -a
  fi
''
