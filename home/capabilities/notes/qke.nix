{ writeShellScriptBin }:

writeShellScriptBin "qke" ''
  file=$(mktemp)
  nvim +startinsert $file
  wl-copy -n < $file
''
