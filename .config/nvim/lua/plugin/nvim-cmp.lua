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
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(), -- Close menu and reject selection
        -- ['<CR>'] = cmp.mapping.confirm({ select = false }),
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
