local cfg = require("lsps/lsp_signature")

local lspconfig = require'lspconfig'
lspconfig.ccls.setup {
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
