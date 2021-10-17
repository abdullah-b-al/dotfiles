local cfg = require("lsps/lsp_signature")

require'lspconfig'.clojure_lsp.setup {
        cmd = {"/home/ab55al/.local/share/nvim/lsp_servers/clojure_lsp/clojure-lsp"},
    -- nvim-cmp setting
    capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities ()),
    -- LSP signature
    require 'lsp_signature'.setup(cfg),
}
