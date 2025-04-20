{ writeShellApplication, ripgrep, bat, fzf }:

writeShellApplication {
  name = "note-search";
  runtimeInputs = [ ripgrep bat fzf ];
  text = ''
    rm -f /tmp/rg-fzf-{r,f}
    RG_PREFIX="rg -l --color=always --smart-case "
    INITIAL_QUERY="''${*:-}"
    : | fzf --ansi --disabled --query "$INITIAL_QUERY" \
        --bind "start:reload($RG_PREFIX {q})+unbind(ctrl-r)" \
        --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
        --bind "ctrl-y:unbind(change,ctrl-f)+change-prompt(  )+enable-search+rebind(ctrl-r)+transform-query(echo {q} > /tmp/rg-fzf-r; cat /tmp/rg-fzf-f)" \
        --bind "ctrl-r:unbind(ctrl-r)+change-prompt(  )+disable-search+reload($RG_PREFIX {q} || true)+rebind(change,ctrl-f)+transform-query(echo {q} > /tmp/rg-fzf-f; cat /tmp/rg-fzf-r)" \
        --prompt '  ' \
        --header '| CTRL-R   | CTRL-Y   |' \
        --preview "bat --color=always --style=grid,numbers '{1}' | rg --pretty --no-line-number --ignore-case --context 20 {q}" \
        --bind 'enter:become(nvim {1})+abort' \
        --bind 'ctrl-d:preview-down' \
        --bind 'ctrl-u:preview-up' \
        --bind 'ctrl-f:preview-half-page-down' \
        --bind 'ctrl-b:preview-half-page-up' \
  '';
}
