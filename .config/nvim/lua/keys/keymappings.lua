local api = vim.api
-- Mapping functions
local nore   = { noremap = true }
local silent = { silent = true }
local snore  = { noremap = true, silent = true }

local function map(mode, lhs, rhs, options)
    options = options or {}
    api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Because I'm lazy
    map('n', ';', ':', nore)
    map('v', ';', ':', nore)

-- Toggle spell on and off
    map('n', '<F12>', ':set spell!<CR>', silent)

-- Terminal mode setting for NeoVim
    map('t', '<Esc>','<C-\\><C-n>', nore)

-- Diff since last save
    map('n', '<leader>d', ':w !diff % -<CR>')

-- Swap cursor movement keys for colemak
    -- map( '', 'n', 'j', nore)
    -- map( '', 'j', 'n', nore)

-- Switch active split
    map('n', '<C-j>', '<C-w>j')
    map('n', '<C-k>', '<C-w>k')
    map('n', '<C-l>', '<C-w>l')
    map('n', '<C-h>', '<C-w>h')

---------- Plugin Mappings

-- VimWiki
    map('n', '<Leader>vw', '<Plug>VimwikiIndex')

-- Telescope
   map('n', '<leader>ff', '<cmd>lua require("telescope.builtin").find_files()<CR>', nore)
   map('n', '<leader>fg', '<cmd>lua require("telescope.builtin").live_grep()<CR>', nore)
   map('n', '<leader>fb', '<cmd>lua require("telescope.builtin").buffers()<CR>', nore)
   map('n', '<leader>fh', '<cmd>lua require("telescope.builtin").help_tags()<CR>', nore)

-- easy motion mappings
    map( '', '<leader>;', '<Plug>(easymotion-next)')
    map( '', '<leader>,', '<Plug>(easymotion-prev)')
    -- Multi line
    map( '', '<leader>f', '<Plug>(easymotion-f)')
    map( '', '<leader>F', '<Plug>(easymotion-F)')
    map( '', '<leader>t', '<Plug>(easymotion-t)')
    map( '', '<leader>T', '<Plug>(easymotion-T)')
    map( '', '<leader>w', '<Plug>(easymotion-bd-w)')
    map( '', '<leader>e', '<Plug>(easymotion-bd-e)')
    map( '', '<leader>n', '<Plug>(easymotion-sn)')
    -- Multi line Overwindows
    map('n', '<leader>wf', '<Plug>(easymotion-overwin-f)')
    map('n', '<leader>wl', '<Plug>(easymotion-overwin-line)')
    map('n', '<leader>ww', '<Plug>(easymotion-overwin-w)')
    -- Same line
    map('', '<leader>if', '<Plug>(easymotion-fl)')
    map('', '<leader>iF', '<Plug>(easymotion-Fl)')
    map('', '<leader>it', '<Plug>(easymotion-tl)')
    map('', '<leader>iT', '<Plug>(easymotion-Tl)')
