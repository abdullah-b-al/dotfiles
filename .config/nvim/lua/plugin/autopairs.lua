local found_autopairs, autopairs = pcall(require, "nvim-autopairs")
local found_cmp, cmp             = pcall(require, 'cmp')

if not found_autopairs then
  print ("Couldn't find autopairs in autopairs.lua")
  return
end

autopairs.setup({
  check_ts = true,
  ts_config = {
    lua = {'string'},-- it will not add a pair on that treesitter node
  }
})

if not found_cmp then
  print("Couldn't find cmp in autopairs.lua")
  return
end

local cmp_auto_pairs = require('nvim-autopairs.completion.cmp')
cmp.event:on("confirm_done", cmp_auto_pairs.on_confirm_done( {map_char = { tex = ""}} ) )
