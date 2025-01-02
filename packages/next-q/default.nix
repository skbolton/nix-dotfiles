{ writeShellScriptBin, dateutils }:

writeShellScriptBin "nextq" ''
  FROM=''${1:-$(date --iso-8601=date)}
  START=2024-12-29

  DIFF=$(($(${dateutils}/bin/datediff $START $FROM -f '%d') % 84))
  ${dateutils}/bin/dateadd $FROM $((84 - $DIFF))d
''
