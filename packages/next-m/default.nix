{ writeShellApplication, dateutils }:

writeShellApplication {
  name = "nextm";
  runtimeInputs = [ dateutils ];
  text = ''
    FROM=''${1:-$(date --iso-8601=date)}
    START=2025-01-05

    DIFF=$(($(datediff "$START" "$FROM" -f '%d') % 28))
    dateadd $FROM $((28 - "$DIFF"))d
  '';
}
