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

    xdg.configFile."nvim/lsp/lua_ls.lua".text = /* lua */ ''
      return {
        cmd = { "lua-language-server" },
        filetypes= {'lua'},
        root_markers = {'.luarc.json', '.git'},
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

    programs.neovim.extraLuaConfig = /* lua */ ''
      vim.lsp.enable('lua_ls')
    '';
  };
}
