{
  writeShellApplication,
  dateutils,
}:

writeShellApplication {
  name = "cycle";

  runtimeInputs = [ dateutils ];

  text = builtins.readFile ./cycle.sh;
}
