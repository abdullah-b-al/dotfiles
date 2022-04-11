local lspconfig = require 'lspconfig'
local signature = require 'lsp_signature'
local cmp       = require('cmp_nvim_lsp')

local cfg = require("lsps/lsp_signature")
local dir = 'lsps'
local path = os.getenv('HOME') .. '/.local/share/nvim/lsp_servers'

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

lspconfig. sumneko_lua.setup {
  on_attach = require(dir .. '/lsp_on_attach'),
  cmd = {path .. '/sumneko_lua/extension/server/bin/lua-language-server'};
  settings = {
    Lua = {
      runtime = {
        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
        version = 'LuaJIT',
        -- Setup your lua path
        path = runtime_path,
      },
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = {'vim'},
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
      -- Do not send telemetry data containing a randomized but unique identifier
      telemetry = {
        enable = false,
      },
    },
  },

  -- nvim-cmp setting
  capabilities = cmp.update_capabilities(vim.lsp.protocol.make_client_capabilities ()),
  -- LSP signature
  signature.setup(cfg),
}
