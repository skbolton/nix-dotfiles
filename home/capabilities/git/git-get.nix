{ writeShellScriptBin }:

writeShellScriptBin "git-get" ''
  set -eu

  DIRECTORY="$HOME/Public"
  NAME="''${2:-$(basename $1 .git)}"

  git clone "$1" "$DIRECTORY/$NAME"
''
