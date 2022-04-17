local found_zk, zk = pcall(require, "zk")
if not found_zk then
  print("Couldn't find zk in zk.lua")
  return
end

local opts = { noremap=true, silent=true }
local map = _G.Mappings.map

local attach = function(bufnr)
  map({'n'}, '<CR>', vim.lsp.buf.definition, opts,
    'Zk: Follow link')
  map({'n'}, 'K', vim.lsp.buf.hover, opts,
    'Zk: Show content of link')
  map({'n'}, '<localleader>r', vim.lsp.buf.references, opts,
    'Zk: Put all references of the link in the quickfix list')
  map({'n'}, '<localleader>e', vim.diagnostic.open_float, opts,
    'Zk: Show link header')
  map('n', '<localleader>s', '<cmd>ZkNotes<CR>', opts,
    'Zk: Search through all notes')
  map('n', '<localleader>b', '<cmd>ZkBacklinks<CR>', opts,
    'Zk: Search through all back links')
  map('n', '<localleader>z', '<cmd>ZkLinks<CR>', opts,
    'Zk: Search through all links')
  map('n', '<localleader>t', '<cmd>ZkTags<CR>', opts,
    'Zk: Search through all tags')
  map('n', '<localleader>n', '<cmd>ZkNew { dir = vim.fn.expand("%:p:h") }<CR>', opts,
    'Zk: Create a new note in the same directory')
  -- The mapping in lua doesn't show anything on the command prompt
  -- map('n', '<localleader>n', ':ZkNew { dir = "" }<Left><Left><Left>', opts)
  -- vim.cmd[[nnoremap <buffer> <localleader>n :ZkNew { dir = "" }<Left><Left><Left>]]
  -- _G.Mappings.add('n', '<localleader>n', 'Zk: Create a new note in the chosen directory')
  vim.cmd[[set conceallevel=2]]
  vim.cmd[[autocmd FileType markdown syn region markdownWikiLink matchgroup=markdownLinkDelimiter start="\[\[" end="\]\]" contains=markdownUrl keepend oneline concealends]]
  vim.cmd[[autocmd FileType markdown syn region markdownWikiLinkidk matchgroup=markdownLinkDelimiter start="`" end="`" contains=markdownUrl keepend oneline concealends]]
end

zk.setup {
  picker = "telescope",

  lsp = {
    -- `config` is passed to `vim.lsp.start_client(config)`
    config = {
      cmd = { "zk", "lsp" },
      name = "zk",
      on_attach = attach,
    },

    -- automatically attach buffers in a zk notebook that match the given filetypes
    auto_attach = {
      enabled = true,
      filetypes = { "markdown" },
    },
  },
}
