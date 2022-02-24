local cfg = require("lsps/lsp_signature")
local path = os.getenv('HOME') .. '/.local/share/nvim/lsp_servers'
local dir = 'lsps'

require'lspconfig'.clangd.setup {
  on_attach = require(dir .. '/lsp_on_attach'),
  cmd = {path .. "/clangd/clangd/bin/clangd"},
  -- nvim-cmp setting
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities ()),
  -- LSP signature
  require 'lsp_signature'.setup(cfg),
}
