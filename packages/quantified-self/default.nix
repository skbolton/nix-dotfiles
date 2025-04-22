{ writeShellApplication, miller, youplot, jq }:

writeShellApplication {
  name = "qs";
  runtimeInputs = [ miller youplot jq ];
  text = ''
    METRIC_DIR="$HOME/Documents/Logbook/Trackers"
    _weight() {
      stats_json=$(mlr --c2j --implicit-csv-header stats1 -a max,min -f 1,2 "$METRIC_DIR/2025-weight.csv" | jq '.[0]')
      smallest_date=$(echo "$stats_json" | jq '.["1_min"]')
      largest_date=$(echo "$stats_json" | jq '.["1_max"]')

      lightest_weight=$(echo "$stats_json" | jq '.["2_min"]')
      heaviest_weight=$(echo "$stats_json" | jq '.["2_max"]')

      uplot line -d, --xlim "$smallest_date,$largest_date" --ylim "$lightest_weight,$heaviest_weight" "$METRIC_DIR/2025-weight.csv"
    }

    _steps() {
      today=$(date --iso-8601=date)
      fourteen_days_ago=$(dateadd "$today" -14d)

      # Shellcheck is not too happy with mlr argument parsing
      # shellcheck disable=SC2016,SC1010
      mlr --csv \
        --implicit-csv-header \
        --headerless-csv-output \
        label date,steps \
        then filter '$date >= "'"$fourteen_days_ago"'"' "$METRIC_DIR/2025-steps.csv" \
        | uplot -d, --title="14 days steps" bar --color magenta
    }

    case "''${1:-weight}" in
      weight)
        _weight
        ;;
      steps)
        _steps
        ;;
    esac
  '';
}
