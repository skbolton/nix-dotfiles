{ writeShellScriptBin }:

writeShellScriptBin "dyear" ''
  DATE="''${1:-$(date --iso-8601)}"
  FILE="$(date '+%Y' --date $DATE).md"
  FILEPATH="$JOURNALS/$FILE"

  _write_template () {
    cat << EOF > "$2"
  ---
  title: $(date '+%Y' --date $DATE)
  ---

  \`\`\`
  $(cal --year --week $DATE | head -n -1)
  \`\`\`

  * [January](./$(date '+%Y-01' --date "$1").md)
  * [February](./$(date '+%Y-02' --date "$1").md)
  * [March](./$(date '+%Y-03' --date "$1").md)
  * [April](./$(date '+%Y-04' --date "$1").md)
  * [May](./$(date '+%Y-05' --date "$1").md)
  * [June](./$(date '+%Y-06' --date "$1").md)
  * [July](./$(date '+%Y-07' --date "$1").md)
  * [August](./$(date '+%Y-08' --date "$1").md)
  * [September](./$(date '+%Y-09' --date "$1").md)
  * [October](./$(date '+%Y-10' --date "$1").md)
  * [November](./$(date '+%Y-11' --date "$1").md)
  * [December](./$(date '+%Y-12' --date "$1").md)
  
  ---
  EOF
  }

  if [ ! -f $FILEPATH ]; then
    _write_template $DATE $FILEPATH
    nvim $FILEPATH
  else
    nvim $FILEPATH
  fi
''

