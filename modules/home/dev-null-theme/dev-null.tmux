# vim: set ft=tmux:
set -g status-interval 3
set-option -g status-position bottom
set-option -g pane-border-style "fg=#202020"
set-option -g pane-active-border-style "fg=#202020"
set-option -g pane-border-lines "single"
set-option -g pane-border-indicators "off"
set-option -g popup-border-style "fg=#202020"
set-option -g popup-border-lines "rounded"
set-option -g message-style "bg=#3DDBD9,fg=black"
set-option -g message-command-style "bg=#3DDBD9,fg=black"
set-option -g popup-border-lines single

# Status line
set -g status-style default
set -g status-right-length 80
set -g status-left-length 100
set -g window-status-separator "  "
set -g status-bg "default"

#Bars ---------------------------------
set -g status-left "#[fg=#202020,bg=#161616]#[fg=#C6C6C6,bg=#202020]  #S #[fg=#202020,bg=#161616]"
set -g status-left-style "fg=#C6C6C6"

set -g status-right "#[fg=#202020,bg=#161616]#[fg=#C6C6C6,bg=#202020] %Y-%m-%d | %H:%M | #[italics]󰲐 #H #[fg=#202020,bg=#161616]"

# Windows ------------------------------
set -g status-justify left

set -g window-status-separator ""
set -g window-status-format "#{?window_zoomed_flag,#[bg=#161616#,fg=#A56EFF]#[bg=#A56EFF#,fg=black] #{?pane_synchronized,#W  ,#W} #[fg=#A56EFF#,bg=#161616],#[bg=#161616#,fg=#202020]#[bg=#202020#,fg=#C6C6C6] #W #[fg=#202020#,bg=#161616]}"
# set -g window-status-format "#{?window_zoomed_flag,#[bg=#011627#,fg=#c792ea]#[bg=#c792ea#,fg=black] #{?pane_synchronized,#W  ,#W} #[fg=#c792ea#,bg=#011627],#[bg=#011627#,fg=#122d42]#[bg=#122d42#,fg=#80A4C2] #W #[fg=#122d42#,bg=#011627]}"
set -g window-status-current-format "#[bg=#161616]#{?window_zoomed_flag,#[fg=#A56EFF],#[fg=#3DDBD9]}#[fg=black]#{?window_zoomed_flag,#[bg=#A56EFF],#[bg=#3DDBD9]} #{?pane_synchronized,#W  ,#W} #[bg=#161616]#{?window_zoomed_flag,#[fg=#A56EFF],#[fg=#3DDBD9]}"
set -g window-status-bell-style "bg=red"
