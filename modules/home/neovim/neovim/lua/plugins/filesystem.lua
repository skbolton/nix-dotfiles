return {
  {
    "oil.nvim",
    after = function()
      require 'oil'.setup {
        default_file_explorer = true,
        columns = {
          "icon",
          "permissions",
        },
        keymaps = {
          -- stub out defaults that clash
          ["<C-s>"] = false,
          ["<C-h>"] = false,
          ["<C-l>"] = false,
          ["<C-x>"] = "actions.select_split",
          ["<C-v>"] = "actions.select_vsplit",
        },
        delete_to_trash = true,
        skip_confirm_for_simple_edits = true,
        view_options = {
          show_hidden = true,
          is_always_hidden = function(name)
            return name == ".." or name == ".git"
          end
        }
      }
    end,
    keys = {
      { "<leader>e", '<CMD>Oil<CR>', "Open oil" }
    },
    cmd = { 'Oil' }
  }
}
