{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.terminal_theme.inspired;
in
{
  options.delta.terminal_theme.inspired = with types; {
    enable = mkEnableOption "Inspired terminal theme";
  };

  config = mkIf cfg.enable {
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
      vim.cmd("hi! Visual guibg=#F4F4F4")
      vim.cmd("hi! link CursorLineNr Keyword")
      vim.cmd("hi! link @markup.link.label Keyword")
      vim.api.nvim_set_hl(0, "@markup.strong", { bold = true })
      vim.api.nvim_set_hl(0, "@markup.heading", { bold = true, sp = "#CA1243", underline = true })
      vim.api.nvim_set_hl(0, "Todo", { bold = true, link = "Function"})
      vim.api.nvim_set_hl(0, "@text.todo.unchecked", { bold = true, link = "Function"})
      vim.api.nvim_set_hl(0, "@text.todo.checked", { link = "Comment"})
      vim.api.nvim_set_hl(0, "DiffChange", { bg = "#DDFFDD"})
      vim.api.nvim_set_hl(0, "DiffAdd", { bg = "#DDFFDD"})
      vim.api.nvim_set_hl(0, "DiffDelete", { bg = "#FFDDDD"})
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#F7F7F7"})
      vim.api.nvim_set_hl(0, "PmenuSel", { bg = "#ebebeb" })
      vim.api.nvim_set_hl(0, "CurSearch", { link = "Search" })
      vim.api.nvim_set_hl(0, "@neorg.tags.ranged_verbatim.code_block", { link = "Visual"})
    '';

    xdg.configFile."nvim/plugin/statusline.lua".source = ./galaxy-line-inspired.lua;
    xdg.configFile."tmux/statusline.tmux".source = ./inspired.tmux;

    programs.kitty.extraConfig = ''
      include themes/inspired-github.conf
    '';

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

    programs.delta = {
      options = {
        light = true;
        decorations = {
          syntax-theme = "GitHub";
        };
        features = "decorations";
      };
    };

    xdg.configFile."aichat/light.tmTheme".text = ''
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple Computer//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
        <dict>
          <key>name</key>
          <string>GitHub</string>
          <key>settings</key>
          <array>
            <dict>
                <key>settings</key>
                <dict>
                    <key>background</key>
                    <string>#FFFFFF</string>
                    <key>caret</key>
                    <string>#333333</string>
                    <key>foreground</key>
                    <string>#333333</string>
                    <key>invisibles</key>
                    <string>#E0E0E0</string>
                    <key>lineHighlight</key>
                    <string>#F8EEC7</string>
                    <key>selection</key>
                    <string>#B0CDE7</string>
                    <key>selectionBorder</key>
                    <string>#B0CDE7</string>
                    <key>inactiveSelection</key>
                    <string>#EDEDED</string>
                    <key>findHighlight</key>
                    <string>#FFE792</string>
                    <key>findHighlightForeground</key>
                    <string>#333333</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>Comments</string>
                <key>scope</key>
                <string>comment</string>
                <key>settings</key>
                <dict>
                    <key>foreground</key>
                    <string>#969896</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>Operators</string>
                <key>scope</key>
                <string>keyword.operator, support.constant</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#A71D5D</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>Operators</string>
                <key>scope</key>
                <string>constant.language</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#0086B3</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>Keywords</string>
                <key>scope</key>
                <string>keyword, storage</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#a71d5d</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>Types</string>
                <key>scope</key>
                <string>storage.type</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#a71d5d</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>Types</string>
                <key>scope</key>
                <string>support.type</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#0086B3</string>
                </dict>
            </dict>
            <dict>
                <key>scope</key>
                <string>variable</string>
                <key>settings</key>
                <dict>
                    <key>foreground</key>
                    <string>#0086b3</string>
                </dict>
            </dict>
            <dict>
                <key>scope</key>
                <string>variable.language</string>
                <key>settings</key>
                <dict>
                    <key>foreground</key>
                    <string>#df5000</string>
                </dict>
            </dict>
            <dict>
                <key>scope</key>
                <string>variable.parameter.function</string>
                <key>settings</key>
                <dict>
                    <key>foreground</key>
                    <string>#333</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>Functions</string>
                <key>scope</key>
                <string>entity.name.function, entity</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#795da3</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>Functions</string>
                <key>scope</key>
                <string>support.function</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#0086B3</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>Classes</string>
                <key>scope</key>
                <string>entity.name.type, entity.other.inherited-class</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#000000</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>Classes</string>
                <key>scope</key>
                <string>support.class</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#0086b3</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>Exceptions</string>
                <key>scope</key>
                <string>entity.name.exception</string>
                <key>settings</key>
                <dict>
                    <key>foreground</key>
                    <string>#F93232</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>Sections</string>
                <key>scope</key>
                <string>entity.name.section</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>Numbers</string>
                <key>scope</key>
                <string>constant.numeric, constant</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#0086b3</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>Strings</string>
                <key>scope</key>
                <string>constant.character, string, string punctuation</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#183691</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>Strings: Regular Expressions</string>
                <key>scope</key>
                <string>string.regexp, string.regexp constant.character, string.regexp punctuation</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#009926</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>Strings: Symbols</string>
                <key>scope</key>
                <string>constant.other.symbol</string>
                <key>settings</key>
                <dict>
                    <key>foreground</key>
                    <string>#990073</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>Embedded Source</string>
                <key>scope</key>
                <string>string source, text source</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#333333</string>
                </dict>
            </dict>
            <dict>
                <key>scope</key>
                <string>variable.other.property</string>
                <key>settings</key>
                <dict>
                    <key>foreground</key>
                    <string>#333</string>
                    <key>fontStyle</key>
                    <string></string>
                </dict>
            </dict>
            <dict>
                <key>scope</key>
                <string>entity.name</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#333333</string>
                </dict>
            </dict>
            <dict>
                <key>scope</key>
                <string>invalid</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#f00</string>
                </dict>
            </dict>


            <!-- HTML -->
            <dict>
                <key>name</key>
                <string>HTML: Tags</string>
                <key>scope</key>
                <string>entity.name.tag</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string />
                    <key>foreground</key>
                    <string>#63a35c</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>HTML: Tags Punctuation</string>
                <key>scope</key>
                <string>punctuation.definition.tag</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string />
                    <key>foreground</key>
                    <string>#333</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>HTML: Attribute Punctuation</string>
                <key>scope</key>
                <string>meta.tag string punctuation</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#183691</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>HTML: Entities</string>
                <key>scope</key>
                <string>constant.character.entity</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#000000</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>HTML: Attribute Names</string>
                <key>scope</key>
                <string>entity.other.attribute-name</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#795da3</string>
                </dict>
            </dict>
            <dict>
                <key>name</key>
                <string>HTML: Attribute Values</string>
                <key>scope</key>
                <string>meta.tag string.quoted, meta.tag string.quoted constant.character.entity</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#183691</string>
                </dict>
            </dict>

            <!-- CSS/SASS -->
            <dict>
                <key>scope</key>
                <string>meta.selector, meta.selector entity, meta.selector entity punctuation, entity.name.tag.css, entity.other.attribute-name.class, keyword.control.html.sass</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#63a35c</string>
                </dict>
            </dict>
            <dict>
                <key>scope</key>
                <string>entity.other.attribute-name.class, constant.other.unit</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#795da3</string>
                </dict>
            </dict>
            <dict>
                <key>scope</key>
                <string>support.type.property-name, support.constant.property-value</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#0086b3</string>
                </dict>
            </dict>


            <!-- Ruby -->
            <dict>
                <key>scope</key>
                <string>keyword.other.special-method.ruby.gem</string>
                <key>settings</key>
                <dict>
                    <key>foreground</key>
                    <string>#0086B3</string>
                    <key>fontStyle</key>
                    <string></string>
                </dict>
            </dict>
            <dict>
                <key>scope</key>
                <string>variable.other.block.ruby</string>
                <key>settings</key>
                <dict>
                    <key>foreground</key>
                    <string>#000</string>
                    <key>fontStyle</key>
                    <string></string>
                </dict>
            </dict>

            <!-- Haskell -->
            <dict>
                <key>scope</key>
                <string>support.function.prelude, variable.other.generic-type.haskell</string>
                <key>settings</key>
                <dict>
                    <key>foreground</key>
                    <string>#000</string>
                    <key>fontStyle</key>
                    <string></string>
                </dict>
            </dict>
            <dict>
                <key>scope</key>
                <string>constant.other.haskell, support.constant.haskell</string>
                <key>settings</key>
                <dict>
                    <key>fontStyle</key>
                    <string></string>
                    <key>foreground</key>
                    <string>#445588</string>
                </dict>
            </dict>

          <!-- Diff -->
          <dict>
            <key>name</key>
            <string>diff.header</string>
            <key>scope</key>
            <string>meta.diff, meta.diff.header</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>#75715E</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>diff.deleted</string>
            <key>scope</key>
            <string>markup.deleted</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>#770000</string>
              <key>background</key>
              <string>#FFDDDD</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>diff.inserted</string>
            <key>scope</key>
            <string>markup.inserted</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>#003300</string>
              <key>background</key>
              <string>#DDFFDD</string>
            </dict>
          </dict>
          <dict>
            <key>name</key>
            <string>diff.changed</string>
            <key>scope</key>
            <string>markup.changed</string>
            <key>settings</key>
            <dict>
              <key>foreground</key>
              <string>#ececec</string>
            </dict>
          </dict>
          </array>
          <key>uuid</key>
          <string>BF4E1964-0DB9-4E88-8142-E8F52D7EDEEC</string>
        </dict>
      </plist>
    '';

    delta.ai.aichat_theme = "light";
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
