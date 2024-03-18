local lspconfig = require 'lspconfig'
local signature = require 'lsp_signature'
local cmp       = require('cmp_nvim_lsp')
local util = require("lspconfig.util")

local cfg = require("lsps/lsp_signature")
local path = os.getenv('HOME') .. '/.local/share/nvim/lsp_servers'
local dir = 'lsps'

lspconfig.ansiblels.setup {
  on_attach = require(dir .. '/lsp_on_attach'),
  -- cmd = {path .. "/zls/package/zls"},
  cmd = {'ansible-language-server', '--stdio'},
  -- nvim-cmp setting
  capabilities = cmp.default_capabilities(vim.lsp.protocol.make_client_capabilities ()),
  -- LSP signature
  signature.setup(cfg),
  filetypes = {'yaml.ansible', "yaml", "yml"},
  root_dir = util.root_pattern("ansible.cfg", ".ansible-lint", "playbook.yaml"),
}
