local lspconfig = require 'lspconfig'
local signature = require 'lsp_signature'
local cmp       = require('cmp_nvim_lsp')

local cfg = require("lsps/lsp_signature")
local path = os.getenv('HOME') .. '/.local/share/nvim/lsp_servers'
local dir = 'lsps'

lspconfig.zls.setup {
  on_attach = require(dir .. '/lsp_on_attach'),
  -- cmd = {path .. "/zls/package/zls"},
  cmd = {'zls'},
  -- nvim-cmp setting
  capabilities = cmp.update_capabilities(vim.lsp.protocol.make_client_capabilities ()),
  -- LSP signature
  signature.setup(cfg),
}
