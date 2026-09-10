#!/usr/bin/env bash
# Planning-cycle boundaries anchored to Sundays. Run with --help for usage.

_usage() {
  cat <<'EOF'
Planning-cycle boundaries anchored to Sundays. Cycles are 84-day quarters of
three 28-day months; every landmark boundary is a Sunday.

usage: cycle [count] [landmark] [--from DATE]

count:    integer, "this" (0), "next" (1), "last" (-1); default 1
landmark: week (7d), month (28d), quarter (84d); default month
          aliases: w, m, q, cycle; plural forms allowed
--from:   reference date, default today
--start:  return the first day of the landmark (default)
--end:    return the last day of the landmark

count 0 is the start of the cycle in progress (today when today is a
boundary); count 1 is the next boundary strictly after --from.

Requires dateutils (datediff, dateadd). The epoch may be overridden via the
CYCLE_EPOCH environment variable.
EOF
}

EPOCH=${CYCLE_EPOCH:-2026-06-21}

FROM=$(date --iso-8601=date)
COUNT=1
LANDMARK=month
END=0

while [ "$#" -gt 0 ]; do
  case $1 in
    --from | -f)
      if [ "$#" -lt 2 ]; then
        echo "cycle: --from requires a date" >&2
        exit 1
      fi
      FROM=$2
      shift 2
      ;;
    --end | -e)
      END=1
      shift
      ;;
    --start | -s)
      END=0
      shift
      ;;
    -h | --help)
      _usage
      exit 0
      ;;
    this)
      COUNT=0
      shift
      ;;
    next)
      COUNT=1
      shift
      ;;
    last | previous)
      COUNT=-1
      shift
      ;;
    *)
      case $1 in
        [0-9]* | -*[0-9]*)
          COUNT=$1
          ;;
        *)
          LANDMARK=$1
          ;;
      esac
      shift
      ;;
  esac
done

LANDMARK=${LANDMARK%s}
case $LANDMARK in
  w | week) LEN=7 ;;
  m | month) LEN=28 ;;
  q | quarter | cycle) LEN=84 ;;
  *)
    echo "cycle: unknown landmark: $LANDMARK" >&2
    exit 1
    ;;
esac

DIFF=$(datediff "$EPOCH" "$FROM" -f '%d')
REM=$((DIFF % LEN))
if [ "$REM" -lt 0 ]; then
  REM=$((REM + LEN))
fi
OFFSET=$((DIFF - REM + COUNT * LEN))
if [ "$END" -eq 1 ]; then
  OFFSET=$((OFFSET + LEN - 1))
fi
dateadd "$EPOCH" "${OFFSET}d"
