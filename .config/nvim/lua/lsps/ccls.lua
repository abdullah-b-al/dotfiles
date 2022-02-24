local cfg = require("lsps/lsp_signature")
local dir = 'lsps'

local lspconfig = require'lspconfig'
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
  capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities ()),
  -- LSP signature
  require 'lsp_signature'.setup(cfg),
}
