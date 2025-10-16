local gl = require 'galaxyline'
local condition = require 'galaxyline.condition'
local vcs = require 'galaxyline.providers.vcs'
local file = require 'galaxyline.providers.fileinfo'
local gls = gl.section
gl.short_line_list = { 'NvimTree', 'vista_kind', 'dbui' }

-----------------------------------------------------------
-- Bar Sections
-----------------------------------------------------------

-- LEFT
-----------------------------------------------------------
gls.left[1] = {
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
    highlight = { "#FFFFFF", "#CA1243" },
    separator = '',
    separator_highlight = { "#CA1243", "#EAEAEA" }
  }
}

gls.left[2] = {
  GitBranch = {
    provider = function()
      if vcs.get_git_branch() then
        return vcs.get_git_branch() .. ' '
      else
        return '· '
      end
    end,
    icon = ' 󰊢  ',
    highlight = { "#000000", "#EAEAEA" },
    separator = '',
    separator_highlight = { "#EAEAEA", "#F5F5F5" }
  }
}

gls.left[3] = {
  GitDiffAdded = {
    icon = ' + ',
    provider = function()
      if vcs.diff_add() then
        return vcs.diff_add()
      else
        return '∅ '
      end
    end,
    highlight = { "#000000", "#F5F5F5" }
  }
}

gls.left[4] = {
  GitDiffChanged = {
    icon = '~ ',
    provider = function()
      if vcs.diff_modified() then
        return vcs.diff_modified()
      else
        return '∅ '
      end
    end,
    highlight = { "#000000", "#F5F5F5" }
  }
}

gls.left[5] = {
  GitDiffRemoved = {
    icon = '- ',
    provider = function()
      if vcs.diff_remove() then
        return vcs.diff_remove()
      else
        return '∅ '
      end
    end,
    highlight = { "#000000", "#F5F5F5" },
    separator = '',
    separator_highlight = { "#F5F5F5", "#FFFFFF" }
  }
}

-- RIGHT
-----------------------------------------------------------

gls.right[1] = {
  LanguageServer = {
    provider = function()
      local active_client = vim.lsp.get_clients()[1]
      if active_client ~= nil then
        return '   '
      else
        return ' 󰖪  '
      end
    end,
    highlight = { "#000000", "#F5F5F5" },
    separator_highlight = { "#F5F5F5", "#FFFFFF" },
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
    highlight = { "#000000", "#EAEAEA" },
    separator_highlight = { "#EAEAEA", "#F5F5F5" },
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
    highlight = { "#FFFFFF", "#CA1243" },
    separator = '',
    separator_highlight = { "#CA1243", "#EAEAEA" }
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
