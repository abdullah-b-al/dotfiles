local opts = { noremap=true, silent=true }
local map = _G.Mappings.map

local attach = function(bufnr)
  map('n', '<CR>', '<cmd>lua vim.lsp.buf.definition()<CR>', opts,
    'Zk: Follow link', bufnr)
  map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts,
    'Zk: Show content of link', bufnr)
  map('n', '<localleader>r', '<cmd>lua vim.lsp.buf.references()<CR>', opts,
    'Zk: Put all references of the link in the quickfix list', bufnr)
  map('n', '<localleader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts,
    'Zk: Show link header', bufnr)
  map('n', '<localleader>s', ':ZkNotes<CR>', opts,
    'Zk: Search through all notes', bufnr)
  map('n', '<localleader>b', ':ZkBacklinks<CR>', opts,
    'Zk: Search through all back links', bufnr)
  map('n', '<localleader>z', ':ZkLinks<CR>', opts,
    'Zk: Search through all links', bufnr)
  map('n', '<localleader>t', ':ZkTags<CR>', opts,
    'Zk: Search through all tags', bufnr)
  map('n', '<localleader>n', ':ZkNew { dir = vim.fn.expand("%:p:h") }<CR>', opts,
    'Zk: Create a new note in the same directory', bufnr)
  -- The mapping in lua doesn't show anything on the command prompt
  -- map('n', '<localleader>n', ':ZkNew { dir = "" }<Left><Left><Left>', opts)
  -- vim.cmd[[nnoremap <buffer> <localleader>n :ZkNew { dir = "" }<Left><Left><Left>]]
  -- _G.Mappings.add('n', '<localleader>n', 'Zk: Create a new note in the chosen directory')
  vim.cmd[[set conceallevel=2]]
  vim.cmd[[autocmd FileType markdown syn region markdownWikiLink matchgroup=markdownLinkDelimiter start="\[\[" end="\]\]" contains=markdownUrl keepend oneline concealends]]
  vim.cmd[[autocmd FileType markdown syn region markdownWikiLinkidk matchgroup=markdownLinkDelimiter start="`" end="`" contains=markdownUrl keepend oneline concealends]]
end

require("zk").setup({
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
  }, })
