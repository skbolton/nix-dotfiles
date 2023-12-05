if vim.g.started_by_firenvim then
  -- turn off some visual clutter
  vim.opt.showtabline = 0
  vim.opt.laststatus = 0
  vim.opt.number = false
  vim.opt.relativenumber = false

  vim.opt.guifont = "Operator Mono Book:h22"
end

vim.g.firenvim_config = {
  localSettings = {
    ['www.notion.so.*'] = {
      takeover = 'never',
      priority = 1
    },
    ['regexr.com'] = {
      takeover = 'never',
      priority = 1
    },
    ['linkedin.*'] = {
      takeover = 'never',
      priority = 1
    },
    ['docs.google.com'] = {
      takeover = 'never',
      priority = 1
    },
    ['outlook.office.com'] = {
      takeover = 'never',
      priority = 1
    },
    [".*"] = {
      takeover = 'nonempty'
    }
  }
}
