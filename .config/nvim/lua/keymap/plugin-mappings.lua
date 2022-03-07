local map = _G.Mappings.map
--{{{1 Telescope
map('n', '<leader>ff', ':Telescope find_files<CR>', { noremap = true },
'Telescope: find files')
map('n', '<leader>fg', ':Telescope live_grep<CR>' , { noremap = true },
  'Telescope: grep cwd')
map('n', '<leader>fb', ':Telescope buffers<CR>'   , { noremap = true },
  'Telescope: Show buffers')
map('n', '<leader>fh', ':Telescope help_tags<CR>' , { noremap = true },
  'Telescope: Show help tage')

--{{{1 easy motion

--{{{2 Global mapping
map('n', '<leader>;', '<Plug>(easymotion-next)', {},
  'EasyMotion: Next char')
map('n', '<leader>,', '<Plug>(easymotion-prev)', {},
  'EasyMotion: Prev char')

--{{{n Multi line
map('n', '<leader>f', '<Plug>(easymotion-bd-f)' , {},
  'EasyMotion: Find char')
map('n', '<leader>t', '<Plug>(easymotion-bd-t)' , {},
  'EasyMotion: Till char')
map('n', '<leader>b', '<Plug>(easymotion-bd-t2)', {},
  'EasyMotion: Till 2-chars')
map('n', 's',         '<Plug>(easymotion-s2)'   , {},
  'EasyMotion: Till 2-chars')

--{{{2 Multi line Overwindows
map('n', '<leader>wl', '<Plug>(easymotion-overwin-line)', {},
  'EasyMotion: Find char over-window')

--{{{1 Limelight
map('n', '<leader>l', ':Limelight!!<CR>', { noremap = true, silent = true },
  'LimeLight: Toggle')
--{{{1 surround.vim
map('n', 'S', '<Plug>Ysurround', {},
  'Surround')
--{{{1 fugitive
map('n', '<F1>', ':tab Git<CR>', { noremap = true, silent = true  },
  'Fugitive: Open in tab')
--{{{1 vim-maximizer
map('n', '<C-w><C-m>', ':MaximizerToggle<CR>', { noremap = true },
  'Maximizer: Toggle')
--{{{1 vim-easy-align
map('v', 'ga', ':EasyAlign<CR>', {},
  'EasyAlign')
--{{{1 Nvim-tree
map('n', '<leader>fo', ':NvimTreeToggle<CR>', { noremap = true },
  'NvimTree: Toggle')
--{{{1 SymbolsOutline
map('n', '<leader>ol', ':SymbolsOutline<CR>', { noremap = true },
  'SymbolsOutline: Toggle')
--{{{1 Gitsings
map('n', '<leader>hp', ':Gitsigns preview_hunk<CR>', { noremap = true },
  'Gitsigns: Preview hunk')