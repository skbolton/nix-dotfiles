require 'todo-comments'.setup {
  highlight = {
    comments_only = false,
    keyword = "fg",
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
    next = { "Keyword" },
    todo = { "Operator" },
    test = { "LineNr" }
  }
}
