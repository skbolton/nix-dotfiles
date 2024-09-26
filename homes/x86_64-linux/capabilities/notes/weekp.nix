{ writeShellScriptBin }:

writeShellScriptBin "dweekp" ''
  DATE="''${1:-$(date --iso-8601)}"
  FILE="$(date '+%Y-W%V' --date $DATE).md"
  FILEPATH="$JOURNALS/$FILE"
  file=$(mktemp)
  nvim +startinsert +"set ft=markdown" $file

  cat $file >> $FILEPATH
''
