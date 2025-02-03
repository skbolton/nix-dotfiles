local has_blink, blink = pcall(require, 'blink.cmp')

local capabilities = nil

if (has_blink) then
  capabilities = blink.get_lsp_capabilities()
else
  capabilities = vim.lsp.protocol.make_client_capabilities()
end

return function() return capabilities end
