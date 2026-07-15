{ lib, config, pkgs, inputs, system, ... }:

with lib;
let
  cfg = config.delta.neovim;

  nvimTreesitterAllGrammars = pkgs.vimPlugins.nvim-treesitter.allGrammars;

  findTreesitterGrammar = name:
    builtins.head (builtins.filter
      (
        grammar: lib.getName grammar == name
      )
      nvimTreesitterAllGrammars);

  markdownTreesitterSourceWithExtensions =
    pkgs.runCommand "tree-sitter-markdown-wiki-link-source"
      {
        nativeBuildInputs = [
          pkgs.nodejs
          pkgs.tree-sitter
        ];
        EXTENSION_WIKI_LINK = "1";
        EXTENSION_TAGS = "1";
      } ''
      cp -r ${(findTreesitterGrammar "tree-sitter-markdown").src} source
      chmod -R +w source

      (cd source/tree-sitter-markdown && tree-sitter generate)
      (cd source/tree-sitter-markdown-inline && tree-sitter generate)

      # Drop the upstream tree-sitter-markdown queries so buildGrammar and
      # nvim-treesitter's grammarToPlugin don't install them. If they were kept,
      # they would shadow nvim-treesitter's own queries/markdown{,_inline}
      # (which include captures like task_list_marker_unchecked) via
      # symlinkJoin precedence.
      rm -rf source/tree-sitter-markdown/queries
      rm -rf source/tree-sitter-markdown-inline/queries

      mv source $out
    '';

  overrideMarkdownGrammarExtensions = grammar:
    grammar.overrideAttrs (old: {
      src = markdownTreesitterSourceWithExtensions;
    });

  overriddenMarkdownGrammars = {
    tree-sitter-markdown = overrideMarkdownGrammarExtensions (findTreesitterGrammar "tree-sitter-markdown");
    tree-sitter-markdown_inline = overrideMarkdownGrammarExtensions (findTreesitterGrammar "tree-sitter-markdown_inline");
  };

  # Wrap each overridden grammar into an nvim-treesitter plugin with
  # installQueries = false. Otherwise grammarToPlugin's isNvimGrammar check
  # fails on our new derivations, sets installQueries = true, and creates
  # an (empty, since we stripped queries above) queries/<lang> directory.
  # That empty dir then wins the symlinkJoin race inside withPlugins and
  # shadows nvim-treesitter's real queries/markdown{,_inline} - the ones
  # that map task_list_marker_unchecked to @markup.list.unchecked, etc.
  # grammarToPlugin is idempotent (guards on `grammar ? origGrammar`), so
  # passing these pre-wrapped plugins through withPlugins is safe.
  overriddenMarkdownGrammarPlugins = lib.mapAttrs
    (
      _name: grammar:
        (pkgs.neovimUtils.grammarToPlugin grammar).overrideAttrs (_: {
          installQueries = false;
        })
    )
    overriddenMarkdownGrammars;

  neovimPackageWithMarkdownExtensions = pkgs.neovim-unwrapped.override {
    treesitter-parsers = pkgs.neovim-unwrapped.treesitter-parsers // {
      markdown = pkgs.neovim-unwrapped.treesitter-parsers.markdown // {
        src = markdownTreesitterSourceWithExtensions;
      };
    };
  };

  neovimPackageWithMarkdownExtensionsChecked = neovimPackageWithMarkdownExtensions.overrideAttrs {
    # Upstream Neovim's treesitter tests assert the stock markdown parse tree.
    # Enabling optional markdown extensions intentionally changes that tree.
    doCheck = false;
  };

  nvimTreesitterWithAllGrammarsAndMarkdownExtensions =
    pkgs.vimPlugins.nvim-treesitter.withPlugins (_:
      map
        (
          grammar:
          let
            name = lib.getName grammar;
          in
          if builtins.hasAttr name overriddenMarkdownGrammarPlugins then
            overriddenMarkdownGrammarPlugins.${name}
          else
            grammar
        )
        nvimTreesitterAllGrammars
    );
in
{
  options.delta.neovim = with types; {
    enable = mkEnableOption "neovim";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.emmet-language-server ];
    programs.neovim = {
      package = neovimPackageWithMarkdownExtensionsChecked;
      enable = true;
      defaultEditor = true;
      withRuby = false;
      withPython3 = true;
      extraPython3Packages = pyPkgs: with pyPkgs; [ beancount ];
      initLua = /* lua */ ''
        require 'options'

        require('lz.n').load("plugins")
      '';
      plugins = with pkgs.vimPlugins; [
        inputs.lz-n.packages.${pkgs.stdenv.hostPlatform.system}.default
        popup-nvim
        plenary-nvim
        nvim-navic
        { plugin = nvim-web-devicons; optional = true; }
        {
          plugin = nvim-web-devicons;
          optional = true;
          config = /* lua */''
            require("mini.icons").setup {}
          '';
          type = "lua";
        }
        { plugin = mini-icons; optional = false; }
        { plugin = bullets-vim; optional = true; }
        { plugin = venn-nvim; optional = true; }
        { plugin = oil-nvim; optional = true; }
        { plugin = inputs.gossip-nvim.packages.${system}.gossip; }

        # editing support
        { plugin = pkgs.awesomeNeovimPlugins.mdeval-nvim; optional = true; }
        { plugin = dial-nvim; optional = true; }
        { plugin = hlchunk-nvim; optional = true; }
        { plugin = vim-tmux-navigator; optional = false; }
        { plugin = nvim-lint; optional = true; }
        { plugin = nvim-autopairs; optional = true; }
        { plugin = firenvim; optional = true; }
        { plugin = vim-surround; optional = true; }
        { plugin = comment-nvim; optional = true; }
        { plugin = vim-repeat; optional = true; }
        { plugin = flash-nvim; optional = true; }
        { plugin = nvim-colorizer-lua; optional = true; }
        { plugin = markdown-preview-nvim; optional = true; }
        { plugin = zk-nvim; optional = true; }
        neorg
        {
          plugin = pkgs.vimUtils.buildVimPlugin {
            name = "spelunk-nvim";
            src = inputs.spelunk-nvim;
            doCheck = false;
          };
          optional = true;
        }
        galaxyline-nvim

        { plugin = aerial-nvim; optional = true; }
        { plugin = blink-cmp; optional = true; }
        { plugin = render-markdown-nvim; optional = true; }
        { plugin = luasnip; optional = true; }

        { plugin = gitsigns-nvim; optional = true; }
        { plugin = diffview-nvim; optional = true; }
        { plugin = vim-fugitive; optional = true; }
        { plugin = git-messenger-vim; optional = true; }
        { plugin = vim-rhubarb; optional = true; }

        # database
        { plugin = vim-dadbod; optional = true; }
        { plugin = vim-dadbod-ui; optional = true; }
        { plugin = vim-dadbod-completion; optional = true; }

        # testing
        { plugin = vim-test; optional = true; }
        { plugin = vim-dispatch; optional = true; }

        nvimTreesitterWithAllGrammarsAndMarkdownExtensions
        { plugin = pkgs.awesomeNeovimPlugins.treewalker-nvim; optional = true; }
        { plugin = nvim-treesitter-textobjects; optional = true; }
        { plugin = nvim-treesitter-endwise; optional = true; }

        {
          plugin = telescope-nvim;
          optional = false;
        }
        {
          plugin = pkgs.vimUtils.buildVimPlugin
            {
              name = "telescope-egrepify-nvim";
              src = inputs.telescope-egrepify-nvim;
            };
          optional = true;
        }
        {
          plugin = telescope-symbols-nvim;
          optional = true;
        }
        {
          plugin = telescope-fzf-native-nvim;
          optional = true;
        }
        {
          plugin = pkgs.awesomeNeovimPlugins.telescope-heading-nvim;
          optional = true;
        }
      ];
    };

    xdg.configFile.nvim = {
      source = ./neovim;
      recursive = true;
    };

    xdg.dataFile."nvim/site/parser/markdown.so".source =
      "${overriddenMarkdownGrammars.tree-sitter-markdown}/parser";

    xdg.dataFile."nvim/site/parser/markdown_inline.so".source =
      "${overriddenMarkdownGrammars.tree-sitter-markdown_inline}/parser";
  };
}
