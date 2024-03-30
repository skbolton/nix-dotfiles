;; extends

;; headers
((atx_heading (atx_h1_marker) @markup.heading)
  (#set! conceal "󰉫 ")
)
((atx_heading (atx_h2_marker) @markup.heading)
  (#set! conceal "󰉬 ")
)
((atx_heading (atx_h3_marker) @markup.heading)
  (#set! conceal "󰉭 ")
)
((atx_heading (atx_h4_marker) @markup.heading)
  (#set! conceal "󰉮 ")
)
((atx_heading (atx_h5_marker) @markup.heading)
  (#set! conceal "󰉯 ")
)

([(list_marker_plus) (list_marker_star)]
  @punctuation.special
  (#offset! @punctuation.special 0 0 0 -1)
  (#set! conceal "•")
)
([(list_marker_plus) (list_marker_star)]
  @punctuation.special
  (#any-of? @punctuation.special "+" "*")
  (#set! conceal "•")
)
((list_marker_minus)
  @punctuation.special
  (#offset! @punctuation.special 0 0 0 -1)
  (#set! conceal "—")
)
((list_marker_minus)
  @punctuation.special
  (#eq? @punctuation.special "-")
  (#set! conceal "—")
)

;; replace '- [x]' with 󰄲
((task_list_marker_checked) @text.todo.checked
  (#offset! @text.todo.checked 0 -2 0 0)
  (#set! conceal "󰄲")
)

;; replace '- [ ]' with 󰄱
((task_list_marker_unchecked) @text.todo.unchecked
  (#offset! @text.todo.unchecked 0 -2 0 0)
  (#set! conceal "󰄱")
)
