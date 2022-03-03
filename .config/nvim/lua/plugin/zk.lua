local opts = { noremap=true, silent=true }

local attach = function(bufnr)
  local function map(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  -- Follow link
  map('n', '<localleader>f', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
  -- Show content of link
  map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
  -- Put all references of the link in the quickfix list
  map('n', '<localleader>r', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  -- Show link header
  map('n', '<localleader>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
  map('n', '<localleader>s', ':ZkNotes<CR>', opts)
  map('n', '<localleader>b', ':ZkBacklinks<CR>', opts)
  map('n', '<localleader>z', ':ZkLinks<CR>', opts)
  map('n', '<localleader>t', ':ZkTags<CR>', opts)
  map('n', '<localleader>nn', ':ZkNew { dir = vim.fn.expand("%:p:h") }<CR>', opts)
  -- The mapping in lua doesn't show anything on the command prompt
  -- map('n', '<localleader>n', ':ZkNew { dir = "" }<Left><Left><Left>', opts)
  vim.cmd[[nnoremap <buffer> <localleader>n :ZkNew { dir = "" }<Left><Left><Left>]]
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
  },
})
