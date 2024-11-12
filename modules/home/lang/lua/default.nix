{ lib, config, pkgs, ... }:

with lib;
let
  cfg = config.delta.lang.elixir;
in
{
  options.delta.lang.lua = with types; {
    enable = mkEnableOption "Lua Language support";
  };

  config = mkIf cfg.enable {
    home.packages = [ pkgs.lua-language-server ];

    xdg.configFile."nvim/after/ftplugin/lua.lua".text = /* lua */ ''
      local capabilities = require 'lsp_capabilities'()

      vim.lsp.start {
        name = 'lua_ls',
        cmd = { "lua-language-server" },
        capabilities = capabilities,
        root_dir = vim.fs.dirname(vim.fs.find({'.luarc.json', '.git'}, { upward = true })[1]),
        on_init = function(client)
          local path = client.workspace_folders[1].name
          if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
            return
          end

          client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
              -- Tell the language server which version of Lua you're using
              -- (most likely LuaJIT in the case of Neovim)
              version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
              checkThirdParty = false,
              library = {
                vim.env.VIMRUNTIME
              }
            }
          })
        end,
        settings = {
          Lua = {}
        }
      }
    '';
  };
}
