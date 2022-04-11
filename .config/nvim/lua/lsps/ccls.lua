local lspconfig = require 'lspconfig'
local signature = require 'lsp_signature'
local cmp       = require('cmp_nvim_lsp')

local cfg = require 'lsps/lsp_signature'
local dir = 'lsps'

lspconfig.ccls.setup {
  on_attach = require(dir .. '/lsp_on_attach'),
  init_options = {
    compilationDatabaseDirectory = "build",
    index = {
      threads = 0,
    },
    clang = {
      excludeArgs = { "-frounding-math"} ,
    },
  },

  -- nvim-cmp setting
  capabilities = cmp.update_capabilities(vim.lsp.protocol.make_client_capabilities ()),
  -- LSP signature
  signature.setup(cfg),
}
