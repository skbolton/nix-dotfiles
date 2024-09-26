{ writeShellScriptBin }:

writeShellScriptBin "dmonth" ''
  DATE="''${1:-$(date --iso-8601)}"
  FILE="$(date '+%Y-%m' --date $DATE).md"
  FILEPATH="$JOURNALS/$FILE"

  _write_template () {
    cat << EOF > "$2"
  ---
  title: $(date '+%B %Y' --date $1)
  ---

  \`\`\`
  $(cal --week $1 | head -n -1)
  \`\`\`

  ---

  [$(date '+%Y' --date $1)](./$(date '+%Y' --date $1).md)

  EOF
  }

  if [ ! -f $FILEPATH ]; then
    _write_template $DATE $FILEPATH
    nvim $FILEPATH
  else
    nvim $FILEPATH
  fi
''

