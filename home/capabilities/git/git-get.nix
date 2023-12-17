{ pkgs }:

pkgs.writeShellScriptBin "git-get" ''
  set -eu

  while getopts ":t" opt; do
    case ''${opt} in
      t)
        DIRECTORY=/tmp/git
        shift
        NAME="''${2:-$(basename $1 .git)}"
        ;;
      *)
        DIRECTORY="$HOME/Public"
        NAME="''${2:-$(basename $1 .git)}"
        ;;
    esac
  done

  git clone "$1" "$DIRECTORY/$NAME"
''
