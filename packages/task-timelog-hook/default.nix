{ writeShellApplication
, jq
, dateutils
, ...
}:
writeShellApplication {
  name = "task-timelog-hook";
  runtimeInputs = [ jq dateutils ];
  text = builtins.readFile ./task-timelog-hook.sh;
}
