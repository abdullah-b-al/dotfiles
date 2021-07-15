local api = vim.api
-- Mapping functions
local nore   = { noremap = true }
local silent = { silent = true }
local snore  = { noremap = true, silent = true }

local function map(mode, lhs, rhs, options)
    options = options or {}
    api.nvim_set_keymap(mode, lhs, rhs, options)
end

-- Toggle spell on and off
    map('n', '<F12>', ':set spell!<cr>', silent)

-- Terminal mode setting for NeoVim
    map('t', '<Esc>','<C-\\><C-n>', nore)

-- Swap cursor movement keys for colemak
    map( '', 'n', 'j', nore)
    map( '', 'j', 'n', nore)

-- VimWiki
    map('n', '<Leader>vw', '<Plug>VimwikiIndex')
    -- nmap <Leader>vw <Plug>VimwikiIndex

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
    -- Multi line Overwindows
    map('n', '<leader>wf', '<Plug>(easymotion-overwin-f)')
    map('n', '<leader>wl', '<Plug>(easymotion-overwin-line)')
    map('n', '<leader>ww', '<Plug>(easymotion-overwin-w)')
    -- Same line
    map('', '<leader>if', '<Plug>(easymotion-fl)')
    map('', '<leader>iF', '<Plug>(easymotion-Fl)')
    map('', '<leader>it', '<Plug>(easymotion-tl)')
    map('', '<leader>iT', '<Plug>(easymotion-Tl)')
