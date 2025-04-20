{ writeShellApplication, fd, khal, entr }:

writeShellApplication {
  name = "agenda";
  runtimeInputs = [ fd khal entr ];
  text = ''
    _agenda() {
      khal list \
        --day-format '{white}{name}, {date}' \
        --format '{calendar-color} {start-time} {end-time} | {title}{reset}{repeat-symbol}{red}{cancelled}{reset}' \
        today "$1 days"
      }

    case "''${1:-agenda}" in
      -w|--watch)
       fd -e items '.' ~/.local/state/vdirsyncer/status | entr -d -c agenda "''${2:-3}"
      ;;
      -*)
      echo "Unknown option $1"
      exit 1
      ;;
      *)
      _agenda "''${1:-3}"
      ;;
    esac
  '';
}
