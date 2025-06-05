local lsp = vim.lsp
local wk = require 'which-key'

local function on_list(options)
  vim.fn.setqflist({}, ' ', options)
  vim.cmd.cfirst()
end

-- LSP Attaching
-- ===================================================================
local formatting_augrop = vim.api.nvim_create_augroup("LSPFORMATTING", {})

vim.api.nvim_create_autocmd('LspAttach', {
  callback = function(env)
    local buffer = env.buf
    local client = vim.lsp.get_client_by_id(env.data.client_id)

    if client:supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = formatting_augrop, buffer = buffer })
      vim.api.nvim_create_autocmd('BufWritePre', {
        group = formatting_augrop,
        buffer = buffer,
        callback = function() lsp.buf.format() end
      })
    end

    if client:supports_method("textDocument/definition") then
      wk.add {
        { "<CR>", function() vim.lsp.buf.definition({ on_list = on_list }) end, desc = "Definition", group = "+lsp", buffer = buffer }
      }
    end

    wk.add {
      { "<leader>lo", "<CMD>Telescope lsp_document_symbols<CR>", desc = "Fuzzy symbols",  group = "+lsp", buffer = buffer },
      { "<leader>lO", "<CMD>AerialToggle!<CR>",                  desc = "Symbol sidebar", group = "+lsp", buffer = buffer },
      { "<leader>li", vim.diagnostic.setloclist,                 desc = "qf diagnostic",  group = "+lsp" },
    }
  end
})
