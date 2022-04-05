local map = _G.Mappings.map
-- Telescope
map('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true },
'Telescope: find files')
map('n', '<leader>fg', ':Telescope live_grep<CR>' , { noremap = true },
  'Telescope: grep cwd')
map('n', '<leader>fb', ':Telescope buffers<CR>'   , { noremap = true },
  'Telescope: Show buffers')
map('n', '<leader>fh', ':Telescope help_tags<CR>' , { noremap = true },
  'Telescope: Show help tage')

-- easy motion

-- Global mapping
map('n', '<leader>;', '<Plug>(easymotion-next)', {},
  'EasyMotion: Next char')
map('n', '<leader>,', '<Plug>(easymotion-prev)', {},
  'EasyMotion: Prev char')

-- Multi line
map('n', '<leader>f', '<Plug>(easymotion-bd-f)' , {},
  'EasyMotion: Find char')
map('n', '<leader>t', '<Plug>(easymotion-bd-t)' , {},
  'EasyMotion: Till char')
map('n', '<leader>b', '<Plug>(easymotion-bd-t2)', {},
  'EasyMotion: Till 2-chars')
map('n', 's',         '<Plug>(easymotion-s2)'   , {},
  'EasyMotion: Till 2-chars')

-- Multi line Overwindows
map('n', '<leader>wl', '<Plug>(easymotion-overwin-line)', {},
  'EasyMotion: Find char over-window')

-- Limelight
map('n', '<leader>l', ':Limelight!!<CR>', { noremap = true, silent = true },
  'LimeLight: Toggle')
-- surround.vim
map('n', 'S', '<Plug>Ysurround', {},
  'Surround')
-- fugitive
map('n', '<F1>', ':tab Git<CR>', { noremap = true, silent = true  },
  'Fugitive: Open in tab')
-- vim-maximizer
map('n', '<C-w><C-m>', ':MaximizerToggle<CR>', { noremap = true },
  'Maximizer: Toggle')
-- vim-easy-align
map('v', 'ga', ':EasyAlign<CR>', {},
  'EasyAlign')
-- Nvim-tree
map('n', '<leader>fo', ':NvimTreeToggle<CR>', { noremap = true },
  'NvimTree: Toggle')
-- SymbolsOutline
map('n', '<leader>ol', ':SymbolsOutline<CR>', { noremap = true },
  'SymbolsOutline: Toggle')
-- Gitsings
map('n', '<leader>hp', ':Gitsigns preview_hunk<CR>', { noremap = true },
  'Gitsigns: Preview hunk')
-- LuaSnip
function my_lua_snip(op)
  local ls = require('luasnip')
  if op == 'jump_forward' and ls.jumpable(1) then
    ls.jump(1)
  elseif op == 'jump_back' and ls.jumpable(-1) then
    ls.jump(-1)
  end
end
map('i', '<C-l>', '<cmd>lua my_lua_snip("jump_forward")<CR>', {},
'LuaSnip: Jump forward')
map('s', '<C-l>', '<cmd>lua my_lua_snip("jump_forward")<CR>', {},
'LuaSnip: Jump forward')
map('i', '<C-h>', '<cmd>lua my_lua_snip("jump_back")<CR>', {},
'LuaSnip: Jump backword')
map('s', '<C-h>', '<cmd>lua my_lua_snip("jump_back")<CR>', {},
'LuaSnip: Jump backword')

--  Harpoon
map('n', '<leader>gg', '<cmd>lua require("harpoon.ui").toggle_quick_menu()<CR>', {} ,
  'Harpoon: Open window')
map('n', '<leader>ga', '<cmd>lua require("harpoon.mark").add_file()<CR>', {},
  'Harpoon: Add file')
map('n', '<leader>gn', '<cmd>lua require("harpoon.ui").nav_file(1)<CR>', {},
  'Harpoon: Navigate to mark 1')
map('n', '<leader>ge', '<cmd>lua require("harpoon.ui").nav_file(2)<CR>', {},
  'Harpoon: Navigate to mark 2')
map('n', '<leader>gi', '<cmd>lua require("harpoon.ui").nav_file(3)<CR>', {},
  'Harpoon: Navigate to mark 3')

-- mini-map
function _G.toggle_minimap()
  vim.cmd[[
  MinimapToggle
  MinimapRefresh
  ]]
end

map('n', '<leader>mm', ':lua _G.toggle_minimap()<CR>', { noremap = true, silent = true },
  'Toggle minimap')
