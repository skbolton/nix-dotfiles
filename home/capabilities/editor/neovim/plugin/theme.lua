local theme = os.getenv("THEME") or "embark"
if theme == "dayfox" then
  vim.o.background = 'light'
  vim.cmd("packadd nightfox.nvim")
  vim.cmd("colorscheme dayfox")
elseif theme == "tantric" then
  vim.cmd('colorscheme tantric')
elseif theme == "dawnfox" then
  vim.o.background = 'light'
  vim.cmd("packadd nightfox.nvim")
  vim.cmd("colorscheme dawnfox")
else
  vim.o.background = 'dark'
  vim.cmd("packadd embark-vim")
  vim.g.embark_terminal_italics = true;
  vim.cmd("colorscheme embark")
end

