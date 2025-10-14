return {
  {
    "vim-dadbod",
    lazy = true,
    before = function()
      vim.g.db_url = os.getenv("DBUI_URL")
    end
  },
  {
    "vim-dadbod-ui",
    before = function()
      vim.g.db_ui_use_nerd_fonts = true
      vim.g.db_ui_execute_on_save = false
      vim.g.db_ui_save_location = "./stevies/db"
      vim.g.db_ui_use_nvim_notify = false
      vim.g.db_ui_disable_mappings = true
      vim.g.db_ui_disable_info_notifications = true
    end,
    after = function()
      local lz = require 'lz.n'
      lz.trigger_load('vim-dadbod')
    end,
    cmd = { "DBUI" }
  },
  {
    "vim-dadbod-completion",
    ft = { 'sql', 'mysql', 'plsql' }
  }
}
