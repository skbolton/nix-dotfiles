;; extends

(shortcut_link
  (link_text) @string (#eq? @string ">") (#offset! @string 0 -1 0 0) (#set! "priority" 110) (#set! conceal " "))

(shortcut_link
  (link_text) @string.special (#eq? @string.special "<") (#offset! @string.special 0 -1 0 0) (#set! "priority" 110) (#set! conceal " "))
