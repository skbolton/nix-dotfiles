local gl = require 'galaxyline'
local vcs = require 'galaxyline.providers.vcs'
local file = require 'galaxyline.providers.fileinfo'
local gls = gl.section
gl.short_line_list = { 'NvimTree', 'vista_kind', 'dbui' }

local colors = {
  bg_0 = "#011627",
  bg_1 = "#122d42",
  bg_2 = "#1d3b53",
  bg_dark = "#010b17",
  bg = "#011627",
  fg = "#d6deeb",
  fg_dark = "#5f7e97"
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
    provider = function()
      return '  '
    end,
    separator = '|',
    separator_highlight = { colors.fg_dark },
    highlight = function()
      if vcs.diff_add() then
        return { "#c5e478", colors.bg_0 }
      else
        return { colors.fg_dark, colors.bg_0 }
      end
    end
  }
}

gls.right[3] = {
  GitDiffChanged = {
    provider = function()
      return '  '
    end,
    highlight = function()
      if vcs.diff_modified() then
        return { "#c792ea", colors.bg_0 }
      else
        return { colors.fg_dark, colors.bg_0 }
      end
    end
  }
}

gls.right[4] = {
  GitDiffRemoved = {
    provider = function()
      return '  '
    end,
    highlight = function()
      if vcs.diff_remove() then
        return { "#EF5350", colors.bg_0 }
      else
        return { colors.fg_dark, colors.bg_0 }
      end
    end
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

vim.api.nvim_create_autocmd('User', {
  pattern = 'GitSignsUpdate',
  callback = function(_args)
    gl.load_galaxyline()
  end
})