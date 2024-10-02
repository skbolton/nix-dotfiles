{ pkgs, ... }:

{

  programs.neovim.plugins = [
    {
      plugin = pkgs.vimUtils.buildVimPlugin {
        name = "inspired-github";
        src = pkgs.fetchFromGitHub {
          owner = "skbolton";
          repo = "inspired-github.vim";
          rev = "108ceda";
          sha256 = "sha256-hLqQWy+S4QHOx7z7+yAxLHTVoyuwUZXThxIJh2gS07M=";
        };
      };
    }
  ];

  xdg.configFile."nvim/plugin/inspired.lua".text = ''
    vim.o.background = 'light'
    vim.cmd("colorscheme inspired-github")
    vim.cmd("hi! Visual guibg=#EFEFEF")
    vim.cmd("hi! link CursorLineNr Keyword")
    vim.cmd("hi! link @markup.link.label Keyword")
    vim.api.nvim_set_hl(0, "@markup.strong", { bold = true })
    vim.api.nvim_set_hl(0, "@markup.heading", { bold = true, sp = "#CA1243", underline = true })
    vim.api.nvim_set_hl(0, "Todo", { bold = true, link = "Function"})
    vim.api.nvim_set_hl(0, "@text.todo.checked", { link = "Comment"})
    vim.api.nvim_set_hl(0, "DiffChange", { bg = "#DDFFDD"})
    vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#DDFFDD"})
    vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#FFDDDD"})
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#F7F7F7"})
  '';

  xdg.configFile."nvim/plugin/statusline.lua".source = ./galaxy-line-inspired.lua;
  xdg.configFile."tmux/statusline.tmux".source = ./inspired.tmux;
  xdg.configFile."kitty/themes/theme.conf".source = ../kitty/themes/inspired-github.conf;

  programs.yazi.theme = {
    manager = {
      hovered = { bg = "#F4F4F4"; };
      tab_active = { bg = "#CA1243"; fg = "black"; };
      tab_inactive = { bg = "#969896"; fg = "black"; };
    };

    status = {
      separator_open = "";
      separator_close = "";
      mode_normal = { fg = "black"; bg = "#CA1243"; };
    };

    input = {
      border = { fg = "#CA1243"; };
      value = { fg = "#000000"; };
    };
  };

  programs.fzf.colors = {
    "bg+" = "#FFFFFF";
    "fg" = "-1";
    "fg+" = "-1";
    "prompt" = "#A71D5D";
    "header" = "#0086B3";
    "pointer" = "#D4BFFF";
    "hl" = "#A71D5D";
    "hl+" = "#A71D5D";
    "spinner" = "#795DA3";
    "info" = "#0086B3";
    "border" = "#969896";
  };

  programs.skim = {
    defaultOptions = [ "--reverse" "--ansi" "--color bg+:#FFFFFF,border:#969896,fg:-1,fg+:-1,header:#0086B3,hl:#A71D5D,hl+:#A71D5D,info:#0086B3,pointer:#D4BFFF,prompt:#A71D5D,spinner:#795DA3" ];
  };

  programs.bat.config.theme = "GitHub";

  programs.btop.settings.color_theme = "flat-remix-light";

  programs.starship.settings = {
    format = "$character$jobs$directory$git_branch$git_status ";
    character = {
      format = "$symbol";
      error_symbol = "[  ](bold fg:#CA1243 bg:#F4F4F4)";
      success_symbol = "[  ](bold fg:#795DA3 bg:#F4F4F4)";
      vimcmd_symbol = "[  ](bold fg:#0086B3 bg:#F4F4F4)";
    };

    directory = {
      format = "[   $path ](fg:#000000 bg:#E0E0E0)[](fg:#E0E0E0)";
    };

    git_branch = {
      format = "[  $branch ](fg:#A71D5D)";
    };

    git_status = {
      style = "bold #795DA3";
    };

    jobs = {
      symbol = "[ 󰠜 ](bg:#E0E0E0 fg:#000000)";
    };

    status = {
      format = "[ $symbol$status ](fg:#000 bg:#CCC)";
      disabled = false;
      symbol = " ";
    };
  };

  programs.git.delta = {
    options = {
      light = true;
      decorations = {
        syntax-theme = "GitHub";
      };
      features = "decorations";
    };
  };
}

# hi Character                  guifg=#0086b3 guibg=None guisp=None gui=None ctermfg=31 ctermbg=None cterm=None
# hi Comment                    guifg=#969896 guibg=None guisp=None gui=italic ctermfg=246 ctermbg=None cterm=italic
# hi Constant                   guifg=#0086b3 guibg=None guisp=None gui=None ctermfg=31 ctermbg=None cterm=None
# hi Cursor                     guifg=None guibg=#ca1243 guisp=None gui=None ctermfg=None ctermbg=236 cterm=None
# hi CursorLine                 guifg=None guibg=#f5f5f5 guisp=None gui=None ctermfg=None ctermbg=255 cterm=None
# hi Function                   guifg=#795da3 guibg=None guisp=None ctermfg=97 ctermbg=None
# hi Identifier                 guifg=#323232 guibg=None guisp=None gui=None ctermfg=236 ctermbg=None cterm=None
# hi Keyword                    guifg=#a71d5d guibg=None guisp=None ctermfg=125 ctermbg=None
# hi LineNr                     guifg=None guibg=None guisp=None gui=None ctermfg=None ctermbg=None cterm=None
# hi Normal                     guifg=#323232 guibg=#ffffff guisp=None gui=None ctermfg=236 ctermbg=15 cterm=None
# hi Number                     guifg=#0086b3 guibg=None guisp=None gui=None ctermfg=31 ctermbg=None cterm=None
# hi Search                     guifg=#323232 guibg=#f8eec7 guisp=None gui=None ctermfg=236 ctermbg=230 cterm=None
# hi StorageClass               guifg=#a71d5d guibg=None guisp=None ctermfg=125 ctermbg=None 
# hi String                     guifg=#183691 guibg=None guisp=None gui=None ctermfg=24 ctermbg=None cterm=None
# hi Type                       guifg=None guibg=None guisp=None gui=None ctermfg=31 ctermbg=None cterm=None
# hi Visual                     guifg=None guibg=#f8eec7 guisp=None gui=None ctermfg=None ctermbg=230 cterm=None
#
