{ writeShellApplication, dateutils }:

writeShellApplication {
  name = "nextq";
  runtimeInputs = [ dateutils ];
  text = ''
    FROM=''${1:-$(date --iso-8601=date)}
    START=2025-01-05

    DIFF=$(($(datediff "$START" "$FROM" -f '%d') % 84))
    dateadd "$FROM" $((84 - "$DIFF"))d
  '';
}
