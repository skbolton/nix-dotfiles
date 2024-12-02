local lsp = vim.lsp
local wk = require 'which-key'

-- Vista Sidebar
-- ===================================================================
vim.g.vista_sidebar_width = 45;
vim.g.vista_default_executive = 'nvim_lsp';
vim.g.vista_disable_statusline = true;
vim.g['vista#renderer#enable_icon'] = 1;
vim.g.vista_icon_indent = { "▸ ", "" };
vim.g['vista#renderer#icons'] = {
  ['function'] = ' ',
  module = '  ',
  variable = ' ',
  constant = ' ',
  event = ' '
}

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

    if client.supports_method("textDocument/definition") then
      wk.add {
        { "<CR>", vim.lsp.buf.definition, desc = "Definition", group = "+lsp", buffer = buffer }
      }
    end

    wk.add {
      { "K", vim.lsp.buf.hover, desc = "Hover", group = "+lsp", buffer = buffer },
      { "<leader>ls", vim.lsp.buf.signature_help, desc = "Signature", group = "+lsp", buffer = buffer },
      { "<leader>lo", "<CMD>Telescope lsp_document_symbols<CR>", desc = "Fuzzy symbols", group = "+lsp", buffer = buffer },
      { "<leader>lO", "<CMD>Vista<CR>", desc = "Symbol sidebar", group = "+lsp", buffer = buffer },
      { "<leader>li", vim.diagnostic.setloclist, desc = "qf diagnostic", group = "+lsp"},
      { "<leader>lr", vim.lsp.buf.references, desc = "qf diagnostic", group = "+lsp", buffer = buffer }
    }
  end
})
