local cmp = require'cmp'
local lspkind = require('lspkind')

vim.opt.completeopt = {'menuone', 'preview'}

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        ['<C-u>'] = cmp.mapping.scroll_docs(-4),
        ['<C-d>'] = cmp.mapping.scroll_docs(4),
        ['<C-e>'] = cmp.mapping.abort(),       -- Close menu and reject selection
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
    },
    formatting = {
        format = lspkind.cmp_format({
            with_text = true,
            mode = 'text',
            menu = {
                buffer   = '[BUF]',
                nvim_lsp = '[LSP]',
                vsnip    = '[VSNIP]',
            },
        })
    },
})
