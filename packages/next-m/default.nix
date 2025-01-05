{ writeShellScriptBin, dateutils }:

writeShellScriptBin "nextm" ''
  FROM=''${1:-$(date --iso-8601=date)}
  START=2025-01-05

  DIFF=$(($(${dateutils}/bin/datediff $START $FROM -f '%d') % 28))
  ${dateutils}/bin/dateadd $FROM $((28 - $DIFF))d
''
