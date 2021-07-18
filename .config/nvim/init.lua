-- Variables
local cmd = vim.cmd
local g = vim.g
local opt = vim.opt
local api = vim.api


-- Options
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


-- Commands
cmd 'packadd paq-nvim'
cmd 'colorscheme focuspoint'
cmd ([[
augroup AutoSaveFolds
    autocmd!
    autocmd BufWinEnter * silent! loadview
    autocmd BufWinLeave * silent! mkview
augroup END
]])


-- Globals
g.mapleader = ' '
g.maplocalleader = '\\'


-- Plugins
local paq = require('paq-nvim').paq
    paq {'savq/paq-nvim', opt = true}       -- paq-nvim manages itself
    paq {'romainl/vim-cool'}                -- disables search highlighting when you are done searching and re-enables it when you search again. 
    paq {'vim-scripts/c.vim'}               -- C IDE
    paq {'ap/vim-css-color'}
    paq {'vimwiki/vimwiki'}
    paq {'scrooloose/syntastic'}
    paq {'tpope/vim-surround'}
    paq {'joom/vim-commentary'}
    paq {'christoomey/vim-system-copy'}
    paq {'michaeljsmith/vim-indent-object'}
    paq {'jiangmiao/auto-pairs'}
    paq {'itchyny/lightline.vim'}
    paq {'easymotion/vim-easymotion'}
    paq {'tpope/vim-repeat'}
    paq {'mhinz/vim-startify'}

    -- Lsp
    paq {'neovim/nvim-lspconfig'}
    paq {'nvim-lua/completion-nvim'}

    -- Telescope
    -- ripgrep needs to be installed for live_grep and similar picker to work
    paq {'nvim-lua/popup.nvim'}
    paq {'nvim-lua/plenary.nvim'}
    paq {'nvim-telescope/telescope.nvim'}


-- Mappings
require('keys/keymappings')


-- Lsp servers
require('lsps/lua_server')


