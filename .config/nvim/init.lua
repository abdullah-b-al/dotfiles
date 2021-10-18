--{{{1 Variables
local cmd = vim.cmd
local g = vim.g
local opt = vim.opt
local api = vim.api
local fn  = vim.fn
local home = vim.env.HOME
local config = home .. '/.config/nvim'


--{{{1 Options
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
opt.cursorline     = true
opt.showmode       = true                                           -- Disabling showmode will hide complete mode
opt.termguicolors  = true
opt.splitbelow     = true
opt.splitright     = true

opt.wrap           = false

opt.dictionary     = opt.dictionary + '/usr/share/dict/words'
opt.spellfile      = home .. '/.config/vim/spell/en.utf-8.add'
opt.viewoptions    = 'cursor,folds'                                 -- save/restore just these with {mk,load}view`


--{{{1 Commands
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


--{{{1 Globals
g.mapleader = ' '
g.maplocalleader = ','
g.colors_name = 'turtles'


--{{{1 Plugins
-- Auto-install paq
local install_path = fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  fn.system({'git', 'clone', '--depth=1', 'https://github.com/savq/paq-nvim.git', install_path})
end
require('paq') {
    {'savq/paq-nvim', opt = true},                             -- paq-nvim manages itself
    'romainl/vim-cool',                                        -- disables search highlighting when you are done searching and re-enables it when you search again.
    'christoomey/vim-system-copy',                             -- Requires xsel
    'ap/vim-css-color',
    'tpope/vim-surround',
    'joom/vim-commentary',
    'michaeljsmith/vim-indent-object',
    'jiangmiao/auto-pairs',
    'itchyny/lightline.vim',
    'tpope/vim-repeat',
    'junegunn/limelight.vim',
    'junegunn/fzf.vim',
    'andymass/vim-matchup',
    'metakirby5/codi.vim',
    'ThePrimeagen/harpoon',
    'tmsvg/pear-tree',
    'guns/vim-sexp',
    'tpope/vim-sexp-mappings-for-regular-people',
    'Olical/conjure',

    -- Movement plugins
    'easymotion/vim-easymotion',
    'unblevable/quick-scope',

    -- Completion and snippets
    'hrsh7th/nvim-cmp',
    'hrsh7th/cmp-nvim-lsp',
    'hrsh7th/cmp-vsnip',
    'hrsh7th/vim-vsnip',
    'hrsh7th/vim-vsnip-integ',
    'rafamadriz/friendly-snippets',

    -- Lsp
    'neovim/nvim-lspconfig',
    'ray-x/lsp_signature.nvim',
    'simrat39/symbols-outline.nvim',
    'williamboman/nvim-lsp-installer',

    -- Telescope
    -- ripgrep needs to be installed for live_grep and similar picker to work
    'nvim-lua/popup.nvim',
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope.nvim',
}


--{{{1 Mappings

--{{{1 Lsp servers
require('lsps/lua_server')
require('lsps/ccls')
require('lsps/clojure_server')
