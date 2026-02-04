{ writeShellApplication
, taskwarrior3
, ...
}:
writeShellApplication {
  name = "task-fs";
  runtimeInputs = [ taskwarrior3 ];
  text = builtins.readFile ./task-fs.sh;
}
