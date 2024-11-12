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
        return vim.fn.expand('%:p:h:t') .. '/' .. vim.fn.expand('%:t') .. ' '
      end
    end,
    highlight = { colors.fg_dark, colors.bg_0 },
  }
}

gls.right[1] = {
  GitBranch = {
    provider = function()
      if vcs.get_git_branch() then
        return vcs.get_git_branch() .. ' '
      else
        return '· '
      end
    end,
    icon = ' 󰊢  ',
    highlight = { colors.fg_dark, colors.bg_0 },
  }
}

gls.right[2] = {
  GitDiffAdded = {
    icon = ' + ',
    provider = function()
      if vcs.diff_add() then
        return vcs.diff_add()
      else
        return '∅ '
      end
    end,
    separator = '|',
    separator_highlight = { colors.fg_dark },
    highlight = { colors.fg_dark, colors.bg_0 },
  }
}

gls.right[3] = {
  GitDiffChanged = {
    icon = '~ ',
    provider = function()
      if vcs.diff_modified() then
        return vcs.diff_modified()
      else
        return '∅ '
      end
    end,
    highlight = { colors.fg_dark, colors.bg_0 },
  }
}

gls.right[4] = {
  GitDiffRemoved = {
    icon = '- ',
    provider = function()
      if vcs.diff_remove() then
        return vcs.diff_remove()
      else
        return '∅ '
      end
    end,
    highlight = { colors.fg_dark, colors.bg_0 },
  }
}

-- RIGHT
-----------------------------------------------------------

gls.right[5] = {
  Position = {
    provider = function()
      local line = vim.fn.line('.')
      local col = vim.fn.col('.')
      return ' ' .. line .. ':' .. col .. ' '
    end,
    separator = '|',
    separator_highlight = { colors.fg_dark },
    highlight = { colors.fg_dark, colors.bg_0 },
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
