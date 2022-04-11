local found_cmp, cmp = pcall(require, 'cmp')
if not found_cmp then
  print("Couldn't find cmp in nvim-cmp.lua")
  return
end

local found_lspkind, lspkind = pcall(require, 'lspkind')
if not found_lspkind then
  print("Couldn't find lspkind in nvim-cmp.lua")
  return
end

local found_luasnip, luasnip = pcall(require, 'luasnip')
if not found_luasnip then
  print("Couldn't find luasnip in nvim-cmp.lua")
  return
end

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
      luasnip.lsp_expand(args.body)
    end
  },
  mapping = {
    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-d>'] = cmp.mapping.scroll_docs(4),
    ['<C-e>'] = cmp.mapping.abort(),       -- Close menu and reject selection
    ['<C-c>'] = cmp.mapping.complete(),
    ['<C-n>'] = cmp.mapping.select_next_item( { behavior = cmp.SelectBehavior.Select }),
    ['<C-p>'] = cmp.mapping.select_prev_item( { behavior = cmp.SelectBehavior.Select }),
  },
  sources = {
  { name = 'nvim_lsp' },
  { name = 'luasnip' },
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
