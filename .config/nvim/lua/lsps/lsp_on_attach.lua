local opts = { noremap=true, silent=true , buffer = 0 }

local on_attach = function(client, bufnr)
  local map = _G.Mappings.map

  client.server_capabilities.semanticTokensProvider = nil

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  map({'n'}, 'gD', vim.lsp.buf.declaration, opts,
    'LSP: Go to declaration')
  map({'n'}, 'gd', vim.lsp.buf.definition, opts,
    'LSP: Go to definition')
  map({'n'}, 'K', vim.lsp.buf.hover, opts,
    'LSP: View documentation')
  map({'n'}, '<C-s>', vim.lsp.buf.signature_help, opts,
    'LSP: Show function signature')
  map({'n'}, '<space>rn', vim.lsp.buf.rename, opts,
    'LSP: Rename symbol')
  map({'n'}, 'gr', vim.lsp.buf.references, opts,
    'LSP: Put references in quickfix list')
  map({'n'}, '<space>e', vim.diagnostic.open_float, opts,
    'LSP: Show diagnostics')
  map({'n'}, ']d', vim.diagnostic.goto_next, opts,
    'LSP: Go to next diagnostic')
  map({'n'}, '[d', vim.diagnostic.goto_prev, opts,
    'LSP: Go to prev diagnostic')
  map({'n'}, '<space>q', vim.diagnostic.setloclist, opts,
    'LSP: Place diagnostics in local quickfix list')
  map({'n'}, '<space>F', vim.lsp.buf.formatting, opts,
    'LSP: Format')
  map({'n'}, '<space>lc', vim.lsp.buf.code_action, opts,
    'LSP: Code action')
end

return on_attach
