local cmd = vim.cmd
local fn = vim.fn
local g = vim.g
local opt = vim.opt
local api = vim.api


-- syntax on
-- filetype plugin on
 
opt.tabstop        = 4
opt.softtabstop    = 4
opt.shiftwidth     = 4
opt.expandtab      = true
opt.smartindent    = true
opt.showmode       = false
opt.nu             = true
opt.wrap           = false
opt.smartcase      = true
opt.incsearch      = true
opt.number         = true
opt.relativenumber = true
opt.spell          = true
opt.dictionary     = opt.dictionary + "/usr/share/dict/words"
opt.spellfile      = "~/.config/vim/spell/en.utf-8.add" 
opt.updatetime     = 1000
opt.timeoutlen     = 300
--set	rtp+=~/.config/vim " add XDG_CONGIF_HOME to runtime path

cmd "packadd paq-nvim"
cmd "colorscheme focuspoint"
-- api.nvim_exec([[let g:auto_save = 1]], false)        -- enable AutoSave on Vim startup

g.mapleader = ' '
g.maplocalleader = '\\'
-- api.nvim_set_keymap( 'n', '<Space>', '<Nop>', {noremap = true} )
-- api.nvim_set_keymap( '', '<Space>', '<Leader>', {} )

-- let g:asyncomplete_enable_for_all = 1

-- """""""""" Terminal mode setting for NeoVim
-- tnoremap <Esc> <C-\><C-n>


-- """""""""" AutoSave Settings
-- let g:auto_save_events = ["InsertLeave", "CursorHold"]

local paq = require('paq-nvim').paq
paq {'savq/paq-nvim', opt = true}    -- paq-nvim manages itself
paq {'ap/vim-css-color'} 
paq {'vimwiki/vimwiki'}
paq {'romainl/vim-cool'}      -- disables search highlighting when you are done searching and re-enables it when you search again. 
paq {'907th/vim-auto-save'}  
paq {'scrooloose/syntastic'}
paq {'vim-scripts/c.vim'}     -- C IDE
paq {'tpope/vim-surround'}
paq {'joom/vim-commentary'}
paq {'christoomey/vim-system-copy'}
paq {'michaeljsmith/vim-indent-object'}
paq {'jiangmiao/auto-pairs'}
paq {'itchyny/lightline.vim'}
-- paq {'liuchengxu/vim-which-key'}
paq {'easymotion/vim-easymotion'}

-- " LSP plugins
--     Plug 'prabirshrestha/vim-lsp'
--     Plug 'mattn/vim-lsp-settings'
--     Plug 'prabirshrestha/asyncomplete.vim'
--     Plug 'prabirshrestha/asyncomplete-lsp.vim'

-- " Fern filemanager
-- 	Plug 'lambdalisue/fern.vim'
-- 	Plug 'lambdalisue/nerdfont.vim'
-- 	Plug 'lambdalisue/fern-renderer-nerdfont.vim'
-- 	Plug 'lambdalisue/glyph-palette.vim'

-- Mappings
require('keys/keymappings')
