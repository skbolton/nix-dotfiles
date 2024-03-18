{ pkgs }:

let
  rg = pkgs.ripgrep;
  bat = pkgs.bat;
  sk = pkgs.skim;
in

pkgs.writeShellScriptBin "note-search" ''
  ${sk}/bin/sk --ansi -c '${rg}/bin/rg -l --ignore-case "{}"' --preview "${bat}/bin/bat --color=always '{1}' | ${rg}/bin/rg --pretty --no-line-number --ignore-case --context 20 --colors 'match:bg:yellow' --colors 'match:fg:black' {cq}"
''
