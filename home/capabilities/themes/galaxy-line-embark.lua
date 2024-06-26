local testing = require 'testing'
local diagrams = require 'diagramming'
local gl = require 'galaxyline'
local vcs = require 'galaxyline.providers.vcs'
local file = require 'galaxyline.providers.fileinfo'
local gls = gl.section
gl.short_line_list = { 'NvimTree', 'vista_kind', 'dbui' }

local colors = {
  bg_0 = "#19172C",
  bg_1 = "#2D2B40",
  bg_2 = "#37354A",
  bg_dark = "#100E23",
  bg = "#1e1c31",
  fg = "#cbe3e7",
  fg_dark = "#8A889D"
}

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
    highlight = { colors.fg_dark, colors.bg_0 },
    separator = '',
    separator_highlight = { colors.bg_0, colors.bg_1 }
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
    highlight = { colors.fg_dark, colors.bg_1 },
    separator = '',
    separator_highlight = { colors.bg_1, colors.bg_2 }
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
    highlight = { colors.fg_dark, colors.bg_2 }
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
    highlight = { colors.fg_dark, colors.bg_2 }
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
    highlight = { colors.fg_dark, colors.bg_2 },
    separator = '',
    separator_highlight = { colors.bg_2, colors.bg_dark }
  }
}

-- RIGHT
-----------------------------------------------------------

gls.right[1] = {
  VennEnabled = {
    provider = function()
      if diagrams.enabled then
        return " "
      else
        return ""
      end
    end,
    highlight = { "#d4bfff", colors.bg_dark },
    separator = '',
  }
}

gls.right[2] = {
  LanguageServer = {
    provider = function()
      local active_client = vim.lsp.buf_get_clients()[1]
      if active_client ~= nil then
        return '   '
      else
        return '   '
      end
    end,
    highlight = { colors.fg_dark, colors.bg_2 },
    separator = '',
    separator_highlight = { colors.bg_2, colors.bg_dark }
  }
}

gls.right[3] = {
  TestResults = {
    provider = function()
      if testing.TESTING_STATUS == 'init' then
        return '   '
      elseif testing.TESTING_STATUS == 'passing' then
        return '   '
      elseif testing.TESTING_STATUS == 'running' then
        return '   '
      elseif testing.TESTING_STATUS == 'failing' then
        return '   '
      end
    end,
    highlight = { colors.fg_dark, colors.bg_1 },
    separator = '',
    separator_highlight = { colors.bg_1, colors.bg_2 }
  }
}

gls.right[4] = {
  Position = {
    provider = function()
      local line = vim.fn.line('.')
      local col = vim.fn.col('.')
      return ' ' .. line .. ':' .. col .. ' '
    end,
    highlight = { colors.fg_dark, colors.bg_0 },
    separator = '',
    separator_highlight = { colors.bg_0, colors.bg_1 }
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
