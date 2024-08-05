{ writeShellScriptBin }:

writeShellScriptBin "dweek" ''
  DATE="''${1:-$(date --iso-8601)}"
  FILE="$(date '+%Y-W%V' --date $DATE).md"
  FILEPATH="$JOURNALS/$FILE"

  _write_template () {
    cat << EOF > "$FILEPATH"
  ---
  title: $(date '+Week %V %Y' --date $DATE)
  ---

  \`\`\`
  $(cal --week $DATE | head -n -1)
  \`\`\`

  ---

  [$(date '+%B' --date $DATE)](./$(date '+%Y-%m').md)
  EOF

  }

  if [ ! -f $FILEPATH ]; then
    _write_template $DATE $FILEPATH
    nvim $FILEPATH
  else
    nvim $FILEPATH
  fi
''

