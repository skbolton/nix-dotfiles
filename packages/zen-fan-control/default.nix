{ writeShellScriptBin }:

writeShellScriptBin "zen-fan-control" ''
  set_fan_state() {
      local state_value

      case $1 in
          0|standard)
              state_value=0
              ;;
          1|quiet)
              state_value=1
              ;;
          2|high)
              state_value=2
              ;;
          3|full)
              state_value=3
              ;;
          *)
              echo "Error: Invalid fan state. Use 0-3 or standard/quiet/high/full."
              exit 1
              ;;
      esac

      echo "Setting fan state to $state_value"
      sudo -i -u root bash << EOF
  cd /sys/kernel/debug/asus-nb-wmi
  echo 0x110019 > dev_id
  echo $state_value > ctrl_param
  cat devs
  EOF
  }

  get_fan_state() {
      state=$(sudo -i -u root bash << EOF
  cd /sys/kernel/debug/asus-nb-wmi
  echo 0x110019 > dev_id
  cat ctrl_param
  EOF
      )
    
      case $state in
          0x00000000)
              echo "Current fan state: Standard (0)"
              ;;
          0x00000001)
              echo "Current fan state: Quiet (1)"
              ;;
          0x00000002)
              echo "Current fan state: High-Performance (2)"
              ;;
          0x00000003)
              echo "Current fan state: Full-Performance (3)"
              ;;
          *)
              echo "Current fan state: Unknown ($state)"
              ;;
      esac
  }

  if [ $# -eq 0 ]; then
      echo "Usage: fan_state [set <0-3|standard|quiet|high|full>|get]"
      exit 1
  fi

  case $1 in
      set)
          if [ $# -ne 2 ]; then
              echo "Error: 'set' command requires an argument (0-3 or standard/quiet/high/full)."
              exit 1
          fi
          set_fan_state $2
          ;;
      get)
          get_fan_state
          ;;
      *)
          echo "Error: Invalid command. Use 'set <0-3|standard|quiet|high|full>' or 'get'."
          exit 1
          ;;
  esac

  exit
''
