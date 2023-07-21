if os.getenv("NVIM_STATUSLINE") == "rocket-line" then
  require('rocket-line')
else
  require('neoline')
end
