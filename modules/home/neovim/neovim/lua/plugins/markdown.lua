-- icons = { '󰎤  ', '󰎧 ', '󰎪 ', '󰎮 ', '󰎰 ', ' 󰎵 ' },
return {
  {
    "render-markdown.nvim",
    after = function()
      require 'render-markdown'.setup {
        file_types = { "markdown" },
        signs = { enabled = false },
        heading = {
          icons = { '󰎤 ', '󰎧 ', '󰎪 ', '󰎭 ', '󰎱 ', '󰎳 ' },
          sign = false,
          position = 'inline',
        },
        link = {
          custom = { youtube = { pattern = '.+youtu%.be.+', icon = ' ' } }
        },
        code = {
          sign = false,
          position = 'right',
          width = 'block',
          min_width = 80,
          border = 'thick'
        },
        bullet = {
          icons = { '•', '∘' }
        },
        checkbox = {
          bullet = true,
          unchecked = {
            icon = '󰄱'
          },
          checked = {
            icon = '󰄲'
          },
          custom = {
            migrated = { raw = '[>]', rendered = ' ', highlight = '@string.special' },
            logged = { raw = '[<]', rendered = ' ', highlight = '@string.special' },
            delegated = { raw = '[/]', rendered = ' ', highlight = '@text.todo.unchecked' },
            inspirational = { raw = '[!]', rendered = ' ', highlight = '@string' },
            priority = { raw = '[*]', rendered = ' ', highlight = '@function' }
          }
        }
      }
    end,
    ft = { "markdown" }
  },
  {
    "bullets.vim",
    before = function()
      vim.g.bullets_outline_levels = { 'num', 'abc', 'std*' }
    end,
    ft = "markdown"
  },
  {
    'venn.nvim',
    ft = "markdown",
    after = function()
      local _M = { enabled = false };

      local toggle_venn = function()
        if not _M.enabled then
          _M.enabled = true
          vim.cmd [[setlocal ve=all]]
          -- draw a line on <C-{HJKL}> keystokes
          vim.api.nvim_buf_set_keymap(0, "n", "<C-J>", "<C-v>j:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "<C-K>", "<C-v>k:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "<C-L>", "<C-v>l:VBox<CR>", { noremap = true })
          vim.api.nvim_buf_set_keymap(0, "n", "<C-H>", "<C-v>h:VBox<CR>", { noremap = true })
          -- draw a box by pressing "f" with visual selection
          vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", { noremap = true })

          vim.keymap.set('n', '<leader>V',
            function()
              vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-v>Elohjok", true, false, true), 'm',
                false)
            end)
          vim.keymap.set('v', '<leader>V', function() vim.api.nvim_feedkeys("lohjok", 't', false) end)
        else
          _M.enabled = false
          vim.cmd [[setlocal ve=]]
          vim.cmd [[mapclear <buffer>]]
        end
      end

      vim.keymap.set('n', '<leader>v', toggle_venn)
    end
  },
}
