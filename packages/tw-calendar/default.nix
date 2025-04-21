{ bundlerApp }:

bundlerApp {
  pname = "taskwarrior-calendar";
  gemdir = ./.;
  exes = [ "task-ical" ];
}
