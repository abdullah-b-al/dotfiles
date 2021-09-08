--{{{1 Mapping functions
local nore    = { noremap = true }
local silent  = { silent  = true }
local snore   = { silent  = true, noremap = true }
local expnore = { expr    = true, noremap = true }

local function map(mode, lhs, rhs, options)
    options = options or {}
    vim.api.nvim_set_keymap(mode, lhs, rhs, options)
end

--{{{1 Toggle spell on and off
map('n', '<F12>', ':set spell!<CR>', silent)

--{{{1 Terminal mode setting for NeoVim
map('t', '<Esc>','<C-\\><C-n>', nore)

--{{{1 Diff since last save
map('n', '<leader>d', ':w !diff % -<CR>')

--{{{1 Substitution
map('', '<leader>ss', ':%s:\\v::cg<Left><Left><Left><Left>', nore)

--{{{1 Accept input from wildmenu and close completion window
map('c', '<S-Tab>', '<C-Y>', nore)

--{{{1 Reselect pasted text
map('n', 'gp', '`[v`]', nore)

--{{{1 Switch active split
map('n', '<C-j>', '<C-w>j')
map('n', '<C-k>', '<C-w>k')
map('n', '<C-l>', '<C-w>l')
map('n', '<C-h>', '<C-w>h')

--{{{1 Yank to the end of the line
map('n', 'Y' , 'y$', nore)

--{{{1 Keep cursor centered on the screen
-- zz centers the curser
map('n', 'n', 'nzzzv', nore)
map('n', 'N', 'Nzzzv', nore)
map('n', 'J', 'mzJ`z', nore)

--{{{1 Undo break points
map('i', ',', ',<C-g>u', nore)
map('i', '.', '.<C-g>u', nore)
map('i', '!', '!<C-g>u', nore)
map('i', '?', '?<C-g>u', nore)

--{{{1 Moving text
map('v', 'J'        , ":m '>+1<CR>gv=gv" , snore)
map('v', 'K'        , ":m '<-2<CR>gv=gv" , snore)

--{{{1 Toggle cursorline and cursorcolumn
map('n', '<leader>cl', ':set cursorline!<CR>', snore)
map('n', '<leader>cc', ':set cursorcolumn!<CR>', snore)

--{{{1 Center cursor after a half page scroll without polluting the jump list
map('n', '<C-d>', '<C-d>zz', nore)
map('n', '<C-u>', '<C-u>zz', nore)

--{{{1 Add large j and k movements to the jump list
map('n', 'k', [[(v:count >= 10 ? "m'" . v:count : '') . 'gk']], expnore)
map('n', 'j', [[(v:count >= 10 ? "m'" . v:count : '') . 'gj']], expnore)

--{{{1 Quicker access to the black hole register
map('n', '_', '"_')

--{{{1 Plugin Mappings

--{{{2 Telescope
map('n', '<leader>tf', '<cmd>lua require("telescope.builtin").find_files()<CR>', nore)
map('n', '<leader>tg', '<cmd>lua require("telescope.builtin").live_grep()<CR>', nore)
map('n', '<leader>tb', '<cmd>lua require("telescope.builtin").buffers()<CR>', nore)
map('n', '<leader>th', '<cmd>lua require("telescope.builtin").help_tags()<CR>', nore)

--{{{2 FZF
map('n', '<leader>ff', ':Files<CR>', snore)
map('n', '<leader>fg', ':Rg<CR>', snore)
map('n', '<leader>fb', ':Buffers<CR>', snore)
map('n', '<leader>fh', ':Helptags<CR>', snore)


--{{{2 easy motion

--{{{3 Global mapping
map( '', '<leader>;', '<Plug>(easymotion-next)')
map( '', '<leader>,', '<Plug>(easymotion-prev)')

--{{{3 Multi line
map( '', '<leader>f', '<Plug>(easymotion-f)')
map( '', '<leader>F', '<Plug>(easymotion-F)')
map( '', '<leader>t', '<Plug>(easymotion-t)')
map( '', '<leader>T', '<Plug>(easymotion-T)')
map( '', '<leader>n', '<Plug>(easymotion-s2)')
map( '', '<leader>b', '<Plug>(easymotion-t2)')

--{{{3 Multi line Overwindows
map('n', '<leader>wl', '<Plug>(easymotion-overwin-line)')

--{{{2 Limelight
map('n', '<leader>lt', '<Plug>(Limelight)')
map('x', '<leader>lt', '<Plug>(Limelight)')
map('n', '<leader>l', ':Limelight!!<CR>', snore)
