local gl = require 'galaxyline'
local condition = require 'galaxyline.condition'
local vcs = require 'galaxyline.providers.vcs'
local file = require 'galaxyline.providers.fileinfo'
local navic = require 'nvim-navic'
local gls = gl.section
gl.short_line_list = { 'NvimTree', 'vista_kind', 'dbui' }

-----------------------------------------------------------
-- Bar Sections
-----------------------------------------------------------

-- LEFT
-----------------------------------------------------------
gls.left[1] = {
  LeftCap = {
    provider = function()
      return ''
    end,
    highlight = { "#3DDBD9", "#161616" },
  }
}

gls.left[2] = {
  FileDetails = {
    icon = function()
      return '  ' .. file.get_file_icon()
    end,
    provider = function()
      local name = file.get_current_file_name()
      if name == '' then
        return 'SCRATCH '
      else
        return name .. ' '
      end
    end,
    highlight = { "#161616", "#3DDBD9" },
    separator = '',
    separator_highlight = { "#3DDBD9", "#252525" }
  }
}

gls.left[3] = {
  GitBranch = {
    provider = function()
      if vcs.get_git_branch() then
        return vcs.get_git_branch() .. ' '
      else
        return '· '
      end
    end,
    icon = ' 󰊢  ',
    highlight = { "#C6C6C6", "#252525" },
    separator = '',
    separator_highlight = { "#252525", "#1B1B1B" }
  }
}

gls.left[4] = {
  Navic = {
    provider = function()
      return ' ' .. navic.get_location() .. ' '
    end,
    condition = function()
      return navic.is_available()
    end,
    highlight = { "#C6C6C6", "#1B1B1B" },
    separator = '',
    separator_highlight = { "#1B1B1B", "#161616" }
  }
}

-- RIGHT
-----------------------------------------------------------

gls.right[1] = {
  LanguageServer = {
    provider = function()
      local active_client = vim.lsp.get_clients()[1]
      if active_client ~= nil then
        return '   ' .. active_client.name .. ' '
      else
        return ' 󰖪  '
      end
    end,
    highlight = { "#C6C6C6", "#1B1B1B" },
    separator_highlight = { "#1B1B1B", "#161616" },
    separator = '',
  }
}

local ai_icons = { init = ' ', running = ' ', complete = ' ' }
local ai_state = 'init'
local ai_msg = ''

local group = vim.api.nvim_create_augroup("MinuetStatusLine", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = group,
  pattern = { 'MinuetRequestStarted', 'MinuetRequestFinished' },
  callback = function(args)
    if args.match == 'MinuetRequestStarted' then
      ai_msg = args.data.model
      ai_state = 'running'
    else
      ai_state = 'complete'
    end

    gl.load_galaxyline()
  end
})

gls.right[2] = {
  AIResults = {
    provider = function()
      if ai_msg == '' then
        return ' '
      else
        return ai_msg .. ' '
      end
    end,
    icon = function()
      return ' ' .. ai_icons[ai_state]
    end,
    highlight = { "#C6C6C6", "#252525" },
    separator_highlight = { "#252525", "#1B1B1B" },
    separator = '',
  }
}

gls.right[3] = {
  Position = {
    provider = function()
      local line = vim.fn.line('.')
      local col = vim.fn.col('.')
      return ' ' .. line .. ':' .. col .. ' '
    end,
    highlight = { "#161616", "#3DDBD9" },
    separator = '',
    separator_highlight = { "#3DDBD9", "#252525" }
  }
}

gls.right[4] = {
  RightCap = {
    provider = function()
      return ''
    end,
    highlight = { "#3DDBD9", "#161616" },
  }
}



-- SHORTLINE
-----------------------------------------------------------
gls.short_line_left[1] = {
  FileName = {
    provider = 'FileName',
    highlight = "PreProc"
  }
}
