-- Variables
local cmd = vim.cmd
local g = vim.g
local opt = vim.opt
local api = vim.api
local home = vim.env.HOME
local config = home .. '/.config/nvim'


-- Options
opt.tabstop        = 4                                              -- Tab width in spaces
opt.softtabstop    = 4                                              -- Tab width in spaces when performing editing operations
opt.shiftwidth     = 4                                              -- Number of spaces to use for each step of (auto)indent
opt.updatetime     = 1000
opt.timeoutlen     = 300

opt.expandtab      = true
opt.smartindent    = true
opt.number         = true                                           -- Current line number
opt.smartcase      = true
opt.incsearch      = true                                           -- Highlights search results as you type
opt.relativenumber = true
opt.spell          = true

opt.showmode       = false
opt.wrap           = false

opt.dictionary     = opt.dictionary + '/usr/share/dict/words'
opt.spellfile      = home .. '/.config/vim/spell/en.utf-8.add'
opt.viewoptions    = 'cursor,folds'                                 -- save/restore just these with {mk,load}view`


-- Commands
cmd 'packadd paq-nvim'
cmd ([[
augroup AutoSaveFolds
    autocmd!
    autocmd BufWinEnter * silent! loadview
    autocmd BufWinLeave * silent! mkview
augroup END
]])
cmd ([[
augroup SpellIgnore
    autocmd BufWinEnter,VimEnter * if filewritable(expand('%')) == 1 && &modifiable == 1 | :set spell | else | :set nospell | endif
augroup END
]])


-- Globals
g.mapleader = ' '
g.maplocalleader = '\\'
vim.g.colors_name = 'gotham256'


-- Plugins
local paq = require('paq-nvim').paq
    paq {'savq/paq-nvim', opt = true}                               -- paq-nvim manages itself
    paq {'romainl/vim-cool'}                                        -- disables search highlighting when you are done searching and re-enables it when you search again.
    paq {'vim-scripts/c.vim'}                                       -- C IDE
    paq {'christoomey/vim-system-copy'}                             -- Requires xsel
    paq {'ap/vim-css-color'}
    paq {'vimwiki/vimwiki'}
    paq {'scrooloose/syntastic'}
    paq {'tpope/vim-surround'}
    paq {'joom/vim-commentary'}
    paq {'michaeljsmith/vim-indent-object'}
    paq {'jiangmiao/auto-pairs'}
    paq {'itchyny/lightline.vim'}
    paq {'easymotion/vim-easymotion'}
    paq {'tpope/vim-repeat'}
    paq {'mhinz/vim-startify'}
    paq {'JamshedVesuna/vim-markdown-preview'}
    paq {'junegunn/limelight.vim'}
    paq {'hrsh7th/nvim-compe'}

    -- Lsp
    paq {'neovim/nvim-lspconfig'}

    -- Telescope
    -- ripgrep needs to be installed for live_grep and similar picker to work
    paq {'nvim-lua/popup.nvim'}
    paq {'nvim-lua/plenary.nvim'}
    paq {'nvim-telescope/telescope.nvim'}


-- Mappings
require('keys/keymappings')
require('keys/nvim-compe')


-- Lsp servers
require('lsps/lua_server')


