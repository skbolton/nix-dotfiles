vim.g.mkdp_theme = 'light'

local keymap = require 'lz.n'.keymap { 'dial.nvim' }

keymap.set("n", "<C-a>", function()
  require("dial.map").manipulate("increment", "normal")
end)

keymap.set("n", "<C-x>", function()
  require("dial.map").manipulate("decrement", "normal")
end)

keymap.set("n", "g<C-a>", function()
  require("dial.map").manipulate("increment", "gnormal")
end)

keymap.set("n", "g<C-x>", function()
  require("dial.map").manipulate("decrement", "gnormal")
end)

keymap.set("v", "<C-a>", function()
  require("dial.map").manipulate("increment", "visual")
end)

keymap.set("v", "<C-x>", function()
  require("dial.map").manipulate("decrement", "visual")
end)

keymap.set("v", "g<C-a>", function()
  require("dial.map").manipulate("increment", "gvisual")
end)

keymap.set("v", "g<C-x>", function()
  require("dial.map").manipulate("decrement", "gvisual")
end)

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = "css,heex,html,elixir,javascriptreact,sass,scss,typescriptreact",
  callback = function()
    vim.lsp.start({
      cmd = { "emmet-language-server", "--stdio" },
      root_dir = vim.fs.dirname(vim.fs.find({ ".git" }, { upward = true })[1]),
      -- Read more about this options in the [vscode docs](https://code.visualstudio.com/docs/editor/emmet#_emmet-configuration).
      -- **Note:** only the options listed in the table are supported.
      init_options = {
        ---@type table<string, string>
        includeLanguages = {},
        --- @type string[]
        excludeLanguages = {},
        --- @type string[]
        extensionsPath = {},
        --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/preferences/)
        preferences = {},
        --- @type boolean Defaults to `true`
        showAbbreviationSuggestions = true,
        --- @type "always" | "never" Defaults to `"always"`
        showExpandedAbbreviation = "always",
        --- @type boolean Defaults to `false`
        showSuggestionsAsSnippets = false,
        --- @type table<string, any> [Emmet Docs](https://docs.emmet.io/customization/syntax-profiles/)
        syntaxProfiles = {},
        --- @type table<string, string> [Emmet Docs](https://docs.emmet.io/customization/snippets/#variables)
        variables = {},
      },
    })
  end,
})
