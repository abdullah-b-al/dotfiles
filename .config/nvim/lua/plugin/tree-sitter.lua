local configs = require("nvim-treesitter.configs")

configs.setup {
  ensure_installed = {
    'bash',
    'c',
    'clojure',
    'cmake',
    'cpp',
    'css',
    'html',
    'json',
    'json5',
    'jsonc',
    'lua',
    'make',
    'markdown',
    'regex',
    'vim',
    'zig',
  },

  sync_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  indent = { enable = true },
}
