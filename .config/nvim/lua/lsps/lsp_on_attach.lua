local opts = { noremap=true, silent=true }

local on_attach = function(client, bufnr)
  local map = _G.Mappings.map

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  map('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts,
    'LSP: Go to declaration', bufnr)
  map('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts,
    'LSP: Go to definition', bufnr)
  map('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts,
    'LSP: View documentation', bufnr)
  map('n', '<C-s>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts,
    'LSP: Show function signature', bufnr)
  map('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts,
    'LSP: Rename symbol', bufnr)
  map('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts,
    'LSP: Put references in quickfix list', bufnr)
  map('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts,
    'LSP: Show diagnostics', bufnr)
  map('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts,
    'LSP: Go to next diagnostic', bufnr)
  map('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts,
    'LSP: Go to prev diagnostic', bufnr)
  map('n', '<space>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts,
    'LSP: Place diagnostics in local quickfix list', bufnr)
  map('n', '<space>F', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts,
    'LSP: Format', bufnr)
end

return on_attach
