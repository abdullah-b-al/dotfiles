local cmd = vim.cmd
local g = vim.g
local opt = vim.opt
local api = vim.api

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
opt.dictionary     = opt.dictionary + '/usr/share/dict/words'
opt.spellfile      = '~/.config/vim/spell/en.utf-8.add'
opt.updatetime     = 1000
opt.timeoutlen     = 300

cmd 'packadd paq-nvim'
cmd 'colorscheme focuspoint'

g.mapleader = ' '
g.maplocalleader = '\\'

api.nvim_exec([[let g:asyncomplete_enable_for_all = 1]], false)
api.nvim_exec([[let g:auto_save = 1]], false)        -- enable AutoSave on Vim startup
api.nvim_exec(
[[
let g:auto_save_events = ["InsertLeave", "CursorHold"]
]], false)


local paq = require('paq-nvim').paq
paq {'savq/paq-nvim', opt = true}       -- paq-nvim manages itself
paq {'romainl/vim-cool'}                -- disables search highlighting when you are done searching and re-enables it when you search again. 
paq {'vim-scripts/c.vim'}               -- C IDE
paq {'ap/vim-css-color'}
paq {'vimwiki/vimwiki'}
paq {'907th/vim-auto-save'}
paq {'scrooloose/syntastic'}
paq {'tpope/vim-surround'}
paq {'joom/vim-commentary'}
paq {'christoomey/vim-system-copy'}
paq {'michaeljsmith/vim-indent-object'}
paq {'jiangmiao/auto-pairs'}
paq {'itchyny/lightline.vim'}
paq {'easymotion/vim-easymotion'}
paq {'tpope/vim-repeat'}
paq {'neovim/nvim-lspconfig'}

-- Mappings
require('keys/keymappings')

-- Lsp servers
require('lsps/lua_server')
