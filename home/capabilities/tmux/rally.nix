{ pkgs }:

pkgs.writeShellScriptBin "rally.sh" ''
  set -eu
  TARGET=$(ls -d ~/Public/* ~/* /tmp/git/* | ${pkgs.fzf}/bin/fzf --header-first --header="Launch Project" --prompt="🔮 " --preview '${pkgs.eza}/bin/eza --tree --icons --color=always --level 3 --git-ignore {}')
  NAME=$(basename $TARGET)
  SESSION_NAME=$(echo $NAME | tr [:lower:] [:upper:])

  ${pkgs.smug}/bin/smug start $NAME -a 2>/dev/null || ${pkgs.smug}/bin/smug start default name=$SESSION_NAME root=$TARGET -a
''
