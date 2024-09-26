vim.opt.background = 'light'
vim.g.colors_name = 'tantric'

local colors = {
  fg = "#37474F",
  bg = "#FFFFFF",
  -- Grey
  G50 = "#FAFAFA",
  -- PMenu and floats
  G100 = "#F5F5F5",
  -- Visual and Cursor Line
  G200 = "#EEEEEE",
  G300 = "#E0E0E0",
  -- LineNr and Border highlights
  G400 = "#BDBDBD",
  -- Operator
  G500 = "#9E9E9E",
  -- Question TODO Use for more
  G600 = "#757575",
  -- Keyword, Error
  G700 = "#616161",
  -- Type
  G800 = "#424242",
  G900 = "#212121",
  -- Blue Grey's
  BG50 = "#ECEFF1",
  BG100 = "#CFD8DC",
  BG200 = "#B0BEC5",
  -- Comment
  BG300 = "#90A4AE",
  BG400 = "#78909C",
  -- Variable
  BG500 = "#607D8B",
  -- Function
  BG600 = "#546E7A",
  -- Function call
  BG700 = "#455A64",
  -- Constants
  BG800 = "#37474F",
  BG900 = "#263238",

  P10 = "#f6f2ff",
  P20 = "#e8daff",
  P30 = "#d4bbff",
  P50 = "#a56eff",
  P60 = "#8a3ffc",
  P70 = "#6929c4",
  P80 = "#491d8b",
  T20 = "#9ef0f0",
  T30 = "#3ddbd9",
  T40 = "#08bdba",
  T50 = "#009d9a",
  T60 = "#007d79",
  R70 = "#a2191f",
  R40 = "#ff8389",
  R30 = "#ffb3b8",
  O50 = "#FFCCBC",
  O100 = "#FFECB3",
  O200 = "#FFAB91",
  O300 = "#FF8A65",
  O600 = "#F4511E",
  O700 = "#E64A19",
  O800 = "#FF8F00",
}

local c = colors

vim.cmd('hi clear')

-- This is a comment
local theme = {
  Normal = { fg = c.fg, bg = c.bg },
  Comment = { fg = c.BG300, italic = true },
  ["@comment"] = { link = "Comment" },
  Visual = { bg = c.G200 },
  -- Search = { bg = c.BG900, fg = c.G50, bold = true},
  Search = { bg = c.P60, fg = c.G50, bold = true },
  CursorLine = { bg = c.G200 },
  CursorColumn = { link = "CursorLine" },
  -- Language Constructs
  Identifier = { fg = c.BG700 },
  ["@variable"] = { fg = c.BG700 },
  -- ["@variable"] = { fg = c.P70 },
  ["@variable.builtin"] = { fg = c.G900, bold = true },
  ["@constructor"] = { fg = c.G900 },
  Operator = { fg = c.BG600, bold = false },
  -- ["@punctuation.bracket"] = { link = "Operator" },
  -- ["@punctuation.bracket"] = { fg = c.BG700 },
  ["@punctuation.bracket"] = { fg = c.P80 },
  ["@punctuation.special"] = { fg = c.P80 },
  -- String = { fg = c.BG900 },
  String = { fg = c.T50 },
  Constant = { fg = c.BG800 },
  ["@symbol"] = { fg = c.P70 },
  Boolean = { fg = c.BG800, bold = true },
  Number = { fg = c.BG800, italic = true },
  Type = { fg = c.BG900, bold = true },
  Keyword = { fg = c.BG500 },
  Repeat = { fg = c.BG700 },
  -- Function = { fg = c.BG600, bold = true },
  Function = { fg = c.P70, bold = true },
  PreProc = { fg = c.BG600 },
  ["@function.call"] = { fg = c.BG700 },
  ["@keyword.function"] = { fg = c.BG500, italic = false },
  ["@method.call"] = { link = "@function.call" },
  Title = { fg = c.G900, bold = true },
  ["@text.strong"] = { link = "Title" },
  ["@text.quote"] = { bg = c.G200, fg = c.G900, italic = true },
  ["@text.reference"] = { fg = c.P70, bold = true },
  ["@text.todo.unchecked"] = { fg = c.P70, bold = true },
  ["@text.todo.checked"] = { fg = c.BG300 },
  ["@text.literal"] = { fg = c.BG400 },
  ["@label"] = { fg = c.P60 },
  -- UI Elements
  LineNr = { fg = c.G400, bg = c.bg },
  CursorLineNr = { fg = c.P60, bold = true },
  EndOfBuffer = { link = "LineNr" },
  SignColumn = { bg = c.bg },
  MatchParen = { bg = c.G200, fg = c.BG900 },
  -- MatchParen = { bg = c.T30, fg = c.fg },
  Pmenu = { bg = c.G100 },
  PmenuSbar = { bg = c.BG200 },
  PmenuThumb = { bg = c.BG600 },
  PmenuSel = { bg = c.BG200 },
  Error = { fg = c.O700, bold = true },
  ErrorMsg = { fg = c.O700, bold = true },
  WarningMsg = { link = "ErrorMsg" },
  Question = { fg = c.BG600 },
  Directory = { fg = c.G800, bold = true },
  Special = { link = "Identifier" },
  SpecialKey = { link = "Directory" },
  SpecialChar = { link = "SpecialKey" },
  SpecialComment = { link = "SpecialKey" },
  Debug = { link = "SpecialKey" },
  NonText = { fg = c.GB600 },
  Tag = { fg = c.GB600 },
  Delimiter = { link = "Tag" },
  DiagnosticError = { fg = c.O200, bg = c.O700 },
  DiagnosticErrorSign = { fg = c.R30 },
  DiagnosticHint = { bg = c.P30, fg = c.P70 },
  DiagnosticSignHint = { fg = c.P70 },
  DiagnosticWarn = { bg = c.O100, fg = c.O600 },
  DiagnosticSignWarn = { fg = c.O600 },

  -- Plugins
  TelescopeBorder = { fg = c.G300 },
  TelescopeSelection = { link = "Visual" },
  TelescopePromptPrefix = { fg = c.P60, bold = true },
  TelescopePromptCounter = { fg = c.T50, bold = true },
  TelescopeMatching = { fg = c.P60, bold = true },

  GitSignsAdd = { fg = c.P60 },
  GitSignsChange = { fg = c.BG400 },
  GitSignsDelete = { fg = c.O800 },
}

function load()
  for group, highlights in pairs(theme) do
    vim.api.nvim_set_hl(0, group, highlights)
  end
end

return { load = load }
