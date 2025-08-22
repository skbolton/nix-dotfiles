{ writeShellApplication
, jq
, dateutils
, ...
}:
writeShellApplication {
  name = "task-timelog-hook";
  runtimeInputs = [ jq dateutils ];
  text = ''
    read -r old_task
    read -r new_task
    TIMESHEET="$HOME/timesheets/time.journal"
    echo "$new_task"

    # started task
    if [ "$(jq 'has("start")' <<< "$new_task")" = "true" ] && [ "$(jq 'has("start")' <<< "$old_task")" = "false" ]; then
      punchin=$(strptime -i "%Y%m%dT%H%M%SZ" -f "%Y/%m/%d %H:%M:%S" "$(jq -r '.start' <<< "$new_task")")
      project=$(jq -r '.project' <<< "$new_task" | tr '.' ':')
      description=$(jq -r '.description' <<< "$new_task")
      tee -a "$TIMESHEET" <<< "i $punchin $project  $description"
    # stopped/completed task
    elif [ "$(jq 'has("start")' <<< "$new_task")" = "false" ] || [ "$(jq 'has("end")' <<< "$new_task")" = "true" ] && [ "$(jq 'has("start")' <<< "$old_task")" = "true" ]; then
      punchout=$(strptime -i "%Y%m%dT%H%M%SZ" -f "%Y/%m/%d %H:%M:%S" "$(jq -r '.modified' <<< "$new_task")")
      tee -a "$TIMESHEET" <<< "o $punchout"
    # modified started task
    # TODO: Implement modifying entry in ledger
    elif [ "$(jq 'has("start")' <<< "$new_task")" = "true" ] && [ "$(jq 'has("start")' <<< "$old_task")" = "true" ]; then
      echo "Active task modifed - Modify $TIMESHEET if needed"
    else
      echo "No timesheet change made"
    fi
  '';
}
