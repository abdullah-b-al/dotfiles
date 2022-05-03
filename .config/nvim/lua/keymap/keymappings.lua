local map = _G.Mappings.map

map({'n'}, 'g?', _G.Mappings.view, { noremap = true, silent = true},
  'View this cheat sheet')

map({'n'}, '<F12>', ':set spell!<CR>', { silent = true},
  'Toggle spell on and off')

--{{{1 Resource init.lua
map({'n'}, '<F5>', ':source ~/.config/nvim/init.lua<CR>', { noremap = true },
  'Reload init.lua')

map({'n'}, '<localleader>,', ':norm ,<CR>', { noremap = true, silent = true},
  'Map ,, to find previous char without triggering other localleader commands')

map({'t'}, '<Esc><Esc>', '<C-\\><C-n>', { noremap = true },
  'Terminal mode setting for NeoVim')

--{{{1 Substitution
map({'n'}, '<leader>s', ':%s:\\v::cg<Left><Left><Left><Left>', { noremap = true },
  'Substitute pattern on whole file')
map({'v'}, '<leader>s', ':s:\\v::cg<Left><Left><Left><Left>', { noremap = true },
  'Substitute pattern on visual selection')

map({'n'}, 'gp', '`[v`]', { noremap = true },
  'Reselect pasted text')
map({'n','v'}, 'p', 'mzp`[v`]=`z', { noremap = true },
  'Format pasted text')
map({'n','v'}, 'P', 'mzP`[v`]=`z', { noremap = true },
  'Format pasted text')

map({'n'}, 'Y', 'y$', { noremap = true },
  'Yank till end of line')

map({'n'}, 'n', 'nzzzv', { noremap = true },
  'Center the cursor after n')
map({'n'}, 'N', 'Nzzzv', { noremap = true },
  'Center the cursor after N')
map({'n'}, 'J', 'mzJ`z', { noremap = true },
  'Center the cursor after J')

-- " {{{1 Undo break points
map({'i'}, ',', ',<C-g>u', { noremap = true },
  'Undo break point at ,')
map({'i'}, '.', '.<C-g>u', { noremap = true },
  'Undo break point at .')
map({'i'}, '!', '!<C-g>u', { noremap = true },
  'Undo break point at !')
map({'i'}, '?', '?<C-g>u', { noremap = true },
  'Undo break point at ?')

map({'n'}, '<leader>cl', ':set cursorline!<CR>', { noremap = true, silent = true },
  'Toggle cursorline')
map({'n'}, '<leader>cc', ':set cursorcolumn!<CR>', { noremap = true , silent = true},
  'Toggle cursorcolumn')

map({'n'}, '//', '/\\v\\c', { noremap = true },
  'Case insensitive pattern search shortcut')

--{{{1 Center cursor after a half page scroll without polluting the jump list
map({'n'}, '<C-d>', '<C-d>zz', { noremap = true })
map({'n'}, '<C-u>', '<C-u>zz', { noremap = true })

map({'n'}, '_', '"_', {},
  'Quicker access to the black hole register')

--{{{1 quickfix mappings
map({'n'}, '<C-l>', ':cnext<CR>zv', { noremap = true },
  'Go to next item in quickfix list')
map({'n'}, '<C-h>', ':cprev<CR>zv', { noremap = true },
  'Go to prev item in quickfix list')
map({'n'}, '<C-q>', ':copen<CR>', { noremap = true },
  'Open quickfix list')
map({'n'}, '<C-Space><C-l>', ':lnext<CR>zv', { noremap = true },
  'Go to next item in local quickfix list')
map({'n'}, '<C-Space><C-h>', ':lprev<CR>zv', { noremap = true },
  'Go to prev item in local quickfix list')
map({'n'}, '<C-Space><C-q>', ':lopen<CR>', { noremap = true },
  'Open local quickfix list')
map({'n'}, '<C-c><C-q>', ':cclose<CR>:lclose<CR>', { noremap = true, silent = true },
  'Close quickfix lists')

-- map({'n'}, 'q:', ':', { noremap = true },
--   'Map the annoying q: to :' )
map({'n'}, 'Q', ':', { noremap = true },
  'Map Q to :')

-- " {{{1 Nicer tab switching
map({'n'}, '<leader>1', '1gt', { noremap = true, silent = true },
  'Move to tab 1')
map({'n'}, '<leader>2', '2gt', { noremap = true, silent = true },
  'Move to tab 2')
map({'n'}, '<leader>3', '3gt', { noremap = true, silent = true },
  'Move to tab 3')
map({'n'}, '<leader>4', '4gt', { noremap = true, silent = true },
  'Move to tab 4')
map({'n'}, '<leader>5', '5gt', { noremap = true, silent = true },
  'Move to tab 5')

-- Cut and replace
map({'n'}, '<leader>vw', 'viwp', {},
  'Replace inside word')
map({'n'}, '<leader>vW', 'viWp', {},
  'Replace inside WORD')
map({'n'}, '<leader>v"', 'vi"p', {},
  'Replace inside "')
map({'n'}, "<leader>v'", "vi'p", {},
  "Replace inside '")
map({'n'}, '<leader>v)', 'vi)p', {},
  'Replace inside )')
map({'n'}, '<leader>v}', 'vi}p', {},
  'Replace inside }')
map({'n'}, '<leader>v]', 'vi]p', {},
  'Replace inside ]')

-- Center cursor after jump list movement
map({'n'}, '<C-i>', '<C-i>zz', { noremap = true },
  'Center cursor after jump list movement')
map({'n'}, '<C-o>', '<C-o>zz', { noremap = true },
  'Center cursor after jump list movement')

-- call :nohl
map({'n'}, 'l', 'l<cmd>nohl<CR>', { noremap = true },
  'call :nohl after movement')
map({'n'}, 'h', 'h<cmd>nohl<CR>', { noremap = true },
  'call :nohl after movement')
map({'n'}, 'k', [[(v:count >= 5 ? "m'" . v:count : '') . 'gk<cmd>nohl<CR>']], { noremap = true, expr = true},
  'Add large j movements to the jump list and call :nohl')
map({'n'}, 'j', [[(v:count >= 5 ? "m'" . v:count : '') . 'gj<cmd>nohl<CR>']], { noremap = true, expr = true},
  'Add large k movements to the jump list and call :nohl')
