
local blocal = vim.opt_local
vim.cmd("packadd markdown-preview.nvim")
vim.cmd("packadd vimplugin-mdeval-nvim")
vim.cmd("packadd vimplugin-edit-code-block.nvim")

require 'mdeval'.setup {
  results_label = "**RESULTS**",
  require_confirmation = false,
  eval_options = {}
}

require 'ecb'.setup {
  wincmd = "vsplit"
}

local run_code_block = function()
  if vim.api.nvim_get_mode()["mode"] == "n" then
    vim.cmd('normal vib"vy')
  else
    vim.cmd('normal "vy')
  end
  vim.cmd("call VimuxRunCommand(@v)")
end

local run_sql_block = function()
  if vim.api.nvim_get_mode()["mode"] == "n" then
    vim.api.nvim_feedkeys(
      vim.api.nvim_replace_termcodes('vib;DB $DBUI_URL<CR>', true, false, true),
      'm',
      false
    )
  end
end

local clock_in = function()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  vim.fn.append(line, {
    string.format("```ledger tangle:%s/%s.timeclock", os.getenv("TIMECARDS"), os.date("%Y-%m-%d")),
    "i " .. os.date("%Y/%m/%d") .. " " .. os.date("%H:%M:%S"),
    "```"
  })
end

local clock_out = function()
  local line = vim.api.nvim_win_get_cursor(0)[1]
  vim.fn.append(line, {
    "o " .. os.date("%Y/%m/%d") .. " " .. os.date("%H:%M:%S"),
  })
end

vim.keymap.set('n', '<localleader>r', '<CMD>MarkdownPreview<CR>', { buffer = true })
vim.keymap.set('n', '<localleader>t', '<CMD>! md-tangle -f %<CR>', { buffer = true })
vim.keymap.set('n', '<C-c><C-c>', run_code_block, { buffer = true })
vim.keymap.set('n', '<C-c><C-x>', '<CMD>MdEval<CR>', { buffer = true })
vim.keymap.set('n', '<C-c><C-e>', '<CMD>EditCodeBlock<CR>', { buffer = true })
vim.keymap.set('n', '<C-c><C-r>', run_sql_block, { buffer = true })
vim.keymap.set('n', '<localleader>ci', clock_in, { buffer = true })
vim.keymap.set('n', '<localleader>co', clock_out, { buffer = true })
vim.keymap.set('n', '<localleader>tt', 'i**<C-R>=strftime("%H:%M")<CR>** ', { buffer = true })
vim.keymap.set('n', '<localleader>td', 'i**<C-R>=strftime("%Y-%m-%d")<CR>** ', { buffer = true })

blocal.textwidth = 120
blocal.softtabstop = 2
blocal.shiftwidth = 2

vim.g.bullets_outline_levels = {'num', 'abc', 'std*'}

-- copied from https://github.com/opdavies/toggle-checkbox.nvim/blob/main/lua/toggle-checkbox.lua
local checked_character = "x"

local checked_checkbox = "%[" .. checked_character .. "%]"
local unchecked_checkbox = "%[ %]"

local line_contains_unchecked = function(line)
  return line:find(unchecked_checkbox)
end

local line_contains_checked = function(line)
  return line:find(checked_checkbox)
end

local line_with_checkbox = function(line)
  -- return not line_contains_a_checked_checkbox(line) and not line_contains_an_unchecked_checkbox(line)
  return line:find("^%s*- " .. checked_checkbox)
    or line:find("^%s*- " .. unchecked_checkbox)
    or line:find("^%s*%d%. " .. checked_checkbox)
    or line:find("^%s*%d%. " .. unchecked_checkbox)
end

local checkbox = {
  check = function(line)
    return line:gsub(unchecked_checkbox, checked_checkbox, 1)
  end,

  uncheck = function(line)
    return line:gsub(checked_checkbox, unchecked_checkbox, 1)
  end,

  make_checkbox = function(line)
    if not line:match("^%s*-%s.*$") and not line:match("^%s*%d%s.*$") then
      -- "xxx" -> "- [ ] xxx"
      return line:gsub("(%S+)", "- [ ] %1", 1)
    else
      -- "- xxx" -> "- [ ] xxx", "3. xxx" -> "3. [ ] xxx"
      return line:gsub("(%s*- )(.*)", "%1[ ] %2", 1):gsub("(%s*%d%. )(.*)", "%1[ ] %2", 1)
    end
  end,
}

local toggle_checkbox = function()
  local bufnr = vim.api.nvim_buf_get_number(0)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local start_line = cursor[1] - 1
  local current_line = vim.api.nvim_buf_get_lines(bufnr, start_line, start_line + 1, false)[1] or ""

  -- If the line contains a checked checkbox then uncheck it.
  -- Otherwise, if it contains an unchecked checkbox, check it.
  local new_line = ""

  if not line_with_checkbox(current_line) then
    new_line = checkbox.make_checkbox(current_line)
  elseif line_contains_unchecked(current_line) then
    new_line = checkbox.check(current_line)
  elseif line_contains_checked(current_line) then
    new_line = checkbox.uncheck(current_line)
  end

  vim.api.nvim_buf_set_lines(bufnr, start_line, start_line + 1, false, { new_line })
  vim.api.nvim_win_set_cursor(0, cursor)
end

vim.keymap.set('n', '<c-space>', toggle_checkbox)

vim.keymap.set("n", "]t", function()
  require("todo-comments").jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
  require("todo-comments").jump_prev()
end, { desc = "Previous todo comment" })

