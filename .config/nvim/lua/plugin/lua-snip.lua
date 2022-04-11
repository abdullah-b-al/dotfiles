local found_luasnip, ls = pcall(require, 'luasnip')

if not found_luasnip then
  print("Couldn't find luasnip in lua-snip.lua")
  return
end

local types = require('luasnip.util.types')

-- Load snippets from friendlysnippets library
require("luasnip.loaders.from_vscode").lazy_load()

ls.config.set_config {
  history = true,

  update_events = 'TextChanged, TextChangedI',

  enable_autosnippets = true,

  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { '<-', 'Error' } },
      },
    },
  },
}

-- load custom snippets
require("luasnip.loaders.from_lua").lazy_load( { path = vim.env.HOME .. '/.config/nvim/luasnippets' } )
