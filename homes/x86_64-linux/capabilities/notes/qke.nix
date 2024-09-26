{ writeShellScriptBin }:

writeShellScriptBin "qke" ''
  file=$(mktemp)
  nvim +startinsert +"set ft=markdown" $file
  wl-copy -n < $file
''
