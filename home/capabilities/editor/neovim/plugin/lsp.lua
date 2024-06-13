local lsp = vim.lsp
local map = vim.keymap.set
local wk = require 'which-key'

-- Vista Sidebar
-- ===================================================================
vim.g.vista_sidebar_width = 45;
vim.g.vista_default_executive = 'nvim_lsp';
vim.g.vista_disable_statusline = true;
vim.g['vista#renderer#enable_icon'] = 1;
vim.g.vista_icon_indent = {"▸ ", ""};
vim.g['vista#renderer#icons'] = {
  ['function'] = ' ',
  module = '  ',
  variable = ' ',
  constant = ' ',
  event = ' '
}

-- Helper Functions
-- ===================================================================
local definition_in_split = function()
  -- open a split, this will carry the current buffer over
  vim.api.nvim_command('vsp')
  -- go to definition
  lsp.buf.definition()
  -- center cursor
  vim.api.nvim_command('normal zz')
end

-- LSP Attaching
-- ===================================================================
local formatting_augrop = vim.api.nvim_create_augroup("LSPFORMATTING", {})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(env)
    vim.cmd("packadd vista.vim")
    local buffer = env.buf
    local client = vim.lsp.get_client_by_id(env.data.client_id)

    if client.supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = formatting_augrop, buffer = buffer })
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = formatting_augrop,
        buffer = buffer,
        callback = function() lsp.buf.format() end
      })
    end

    wk.register({
      ["<CR>"] = { vim.lsp.buf.definition, "definition" },
      K = { vim.lsp.buf.hover, "hover" },
      l = {
        name = "+lsp",
        s = { vim.lsp.buf.signature_help, "signature" },
        o = { "<CMD>Telescope lsp_document_symbols<CR>", "fuzzy symbol" },
        O = { "<CMD>Vista<CR>", "sidebar" },
        i = {vim.diagnostic.setloclist, "qf diagnostics" }
      }
    }, { buffer = buffer })
  end
})
