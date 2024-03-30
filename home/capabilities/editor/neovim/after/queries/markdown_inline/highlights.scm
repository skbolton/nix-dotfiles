;; extends

;; bullet journal extends
;; migration forward
(shortcut_link
  (link_text) @string (#eq? @string ">") (#offset! @string 0 -1 0 0) (#set! "priority" 110) (#set! conceal " "))

;; migration -> future log
(shortcut_link
  (link_text) @string.special (#eq? @string.special "<") (#offset! @string.special 0 -1 0 0) (#set! "priority" 110) (#set! conceal " "))

;; delegated
(shortcut_link
  (link_text) @text.todo.unchecked (#eq? @text.todo.unchecked "/") (#offset! @text.todo.unchecked 0 -1 0 0) (#set! "priority" 110) (#set! conceal " "))

;; priority
(shortcut_link
  (link_text) @function (#eq? @function "*") (#offset! @function 0 -1 0 0) (#set! "priority" 110) (#set! conceal " "))

;; inspirational
(shortcut_link
  (link_text) @constant (#eq? @constant "!") (#offset! @constant 0 -1 0 0) (#set! "priority" 110) (#set! conceal " "))
