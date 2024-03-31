local found_lspconfig = pcall(require, 'lspconfig')
local found_signature = pcall(require, 'lsp_signature')
local found_cmp       = pcall(require, 'cmp_nvim_lsp')

if not found_lspconfig then
  print("Couldn't find lspconfig in lsps/init.lua")
  return
end
if not found_signature then
  print("Couldn't find lsp-signature in lsps/init.lua")
  return
end
if not found_cmp then
  print("Couldn't find cmp in lsps/init.lua")
  return
end

local lspconfig = require 'lspconfig'
local signature = require 'lsp_signature'
local cmp       = require('cmp_nvim_lsp')

local cfg = require("lsps/lsp_signature")
local path = os.getenv('HOME') .. '/.local/share/nvim/lsp_servers'
local dir = 'lsps'

local servers = {
  'zls',
  'gopls',
  'clangd',
  'pylsp',
}

for _, server in ipairs(servers) do

  lspconfig[server].setup{
      on_attach = require(dir .. '/lsp_on_attach'),
      cmd = {server},
      -- nvim-cmp setting
      capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities ()),
      -- LSP signature
      signature.setup(cfg),
  }
end

-- lspconfig.zls.setup {
--   on_attach = require(dir .. '/lsp_on_attach'),
--   -- cmd = {path .. "/zls/package/zls"},
--   cmd = {'zls'},
--   -- nvim-cmp setting
--   capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities ()),
--   -- LSP signature
--   signature.setup(cfg),
-- }

local dir = 'lsps'
return {
  -- require(dir .. '/ccls'),
  -- require(dir .. '/omnisharp'),
  -- require(dir .. '/clojure_server'),
  -- require(dir .. '/clangd'),
  -- require(dir .. '/lua_server'),
  -- require(dir .. '/zig_server'),
  -- require(dir .. '/go_server'),
  -- require(dir .. '/ansible'),
  -- require(dir .. '/python_server'),
  -- require(dir .. '/cmake_server'),
}
