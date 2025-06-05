;; extends

;; wikilink conceal
(wiki_link
  [
    "["
    "["
    "|"
    "]"
    "]"
    (link_destination)
  ] @markup.link
  (#set! conceal ""))

(tag) @function.call
