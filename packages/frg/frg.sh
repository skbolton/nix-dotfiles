RG_PREFIX="rg --column --line-number --no-heading --color=always --smart-case --hidden -g '!.git'"
INITIAL_QUERY="${*:-}"

fzf --ansi --disabled --query "$INITIAL_QUERY" \
  --multi \
  --delimiter ':' \
  --bind "start:reload($RG_PREFIX {q} || true)" \
  --bind "change:reload:sleep 0.1; $RG_PREFIX {q} || true" \
  --prompt '  ' \
  --preview "bat --color=always --style=grid,numbers --highlight-line '{2}' '{1}'" \
  --preview-window 'up,60%' \
  --bind 'ctrl-a:select-all' \
  --bind 'ctrl-d:preview-down' \
  --bind 'ctrl-u:preview-up' \
  --bind 'ctrl-f:preview-half-page-down' \
  --bind 'ctrl-b:preview-half-page-up'
