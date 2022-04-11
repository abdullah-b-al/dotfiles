local found_treesitter, configs = pcall(require, "nvim-treesitter.configs")
if not found_treesitter then
  print("Couldn't find treesitter in tree-sitter.lua")
  return
end
  
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
