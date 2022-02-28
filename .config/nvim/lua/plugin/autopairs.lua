local autopairs = require("nvim-autopairs")

-- change default fast_wrap
autopairs.setup({
  fast_wrap = {
    map = '<C-s>',
    chars = { '{', '[', '(', '"', "'" },
    pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
    offset = 0, -- Offset from pattern match
    end_key = '$',
    keys = 'qwertyuiopzxcvbnmasdfghjkl',
    check_comma = true,
    highlight = 'Search',
    highlight_grey='Comment'
  },
})

autopairs.setup({
  check_ts = true,
  ts_config = {
    lua = {'string'},-- it will not add a pair on that treesitter node
  }
})

local cmp_auto_pairs = require('nvim-autopairs.completion.cmp')
require('cmp').event:on("confirm_done", cmp_auto_pairs.on_confirm_done( {map_char = { tex = ""}} ) )
