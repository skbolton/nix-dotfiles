local testing = require 'testing'
local diagrams = require 'diagramming'
local gl = require 'galaxyline'
local condition = require 'galaxyline.condition'
local vcs = require 'galaxyline.providers.vcs'
local file = require 'galaxyline.providers.fileinfo'
local gls = gl.section
gl.short_line_list = { 'NvimTree', 'vista_kind', 'dbui' }

-- Read from testing.lua module
-- and adjust icon and color per testing state
local testing_results = function()
  if testing.TESTING_STATUS == 'init' then
    return " "
  elseif testing.TESTING_STATUS == 'passing' then
    return " "
  elseif testing.TESTING_STATUS == 'running' then
    return " "
  elseif testing.TESTING_STATUS == 'failing' then
    return " "
  end
end


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
  VennEnabled = {
    provider = function()
      if diagrams.enabled then
        return " "
      else
        return ""
      end
    end,
    highlight = { "#795DA3", "#FFFFFF" },
    separator = '',
  }
}

gls.right[2] = {
  LanguageServer = {
    provider = function()
      active_client = vim.lsp.buf_get_clients()[1]
      if active_client ~= nil then
        return '   '
      else
        return '   '
      end
    end,
    highlight = { "#000000", "#F5F5F5" },
    separator_highlight = { "#F5F5F5", "#FFFFFF" },
    separator = '',
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
    highlight = { "#000000", "#EAEAEA" },
    separator_highlight = { "#EAEAEA", "#F5F5F5" },
    separator = '',
  }
}

gls.right[4] = {
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
