require 'todo-comments'.setup {
  highlight = {
    comments_only = false,
    keyword = "bg",
    after = "",
  },
  keywords = {
    NEXT = { icon = " ", color = "next"},
    TODO = { icon = " ", color = "todo" },
    DONE = { icon = " ", color = "hint" },
    WAIT = { icon = " ", color = "warning" },
    BLOCK = { icon = "󰒡 ", color = "error"},
    CANC = { icon = " ", color = "test", alt = {"MAYBE"}}
  },
  colors = {
    hint = { "CursorLineNr" },
    next = { "Keyword" },
    todo = { "Directory" },
    test = { "LineNr" }
  }
}
