local cmp = require'cmp'
local lspkind = require('lspkind')

vim.opt.completeopt = {'menuone', 'preview'}

cmp.setup({
  experimental = {
    ghost_text = true,
  },
  completion = {
    keyword_length = 2,
  },
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),       -- Close menu and reject selection
    ['<C-c>'] = cmp.mapping.complete(),
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

_G.Mappings.add('i', '<C-u>', 'Cmp: Scroll docs. up')
_G.Mappings.add('i', '<C-d>', 'Cmp: Scroll docs. down')
_G.Mappings.add('i', '<C-e>', 'Cmp: Abort completion')
_G.Mappings.add('i', '<C-c>', 'Cmp: Show completion menu')
