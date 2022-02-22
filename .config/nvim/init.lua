--{{{1 Variables
local cmd = vim.cmd
local g = vim.g
local opt = vim.opt
local api = vim.api
local fn  = vim.fn
local home = vim.env.HOME
local config = home .. '/.config/nvim'
local after = config .. '/after'


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
cmd 'packadd packer.nvim'


--{{{1 Globals
g.mapleader = ' '
g.maplocalleader = ','


--{{{1 Plugins
-- Auto-install packer
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'

if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth=1', 'https://github.com/wbthomason/packer.nvim', install_path})
end

local packer = require "packer"
local use    = packer.use
packer.startup(function()
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'
    -- disables search highlighting when you are done searching and re-enables it when you search again.
    use 'romainl/vim-cool'
    -- Requires xsel
    use 'christoomey/vim-system-copy'
    use 'ap/vim-css-color'
    use 'tpope/vim-surround'
    use 'joom/vim-commentary'
    use 'michaeljsmith/vim-indent-object'
    use 'jiangmiao/auto-pairs'
    use 'tpope/vim-repeat'
    use 'junegunn/limelight.vim'
    use 'andymass/vim-matchup'
    use 'metakirby5/codi.vim'
    use 'ThePrimeagen/harpoon'
    use 'guns/vim-sexp'
    use 'tpope/vim-sexp-mappings-for-regular-people'
    use 'Olical/conjure'
    use 'nvim-lualine/lualine.nvim'
    use 'kyazdani42/nvim-web-devicons'
    use 'wellle/targets.vim'
    use 'ziglang/zig.vim'
    use 'preservim/vimux'
    use 'tpope/vim-fugitive'
    use 'szw/vim-maximizer'
    use 'puremourning/vimspector'
    use 'junegunn/vim-easy-align'
    use 'TaDaa/vimade'
    use 'nvim-treesitter/nvim-treesitter'
    use 'lukas-reineke/indent-blankline.nvim'

    -- color schemes
    use 'ellisonleao/gruvbox.nvim'

    -- Movement plugins
    use 'easymotion/vim-easymotion'
    use 'unblevable/quick-scope'

    -- Completion and snippets
    use 'hrsh7th/nvim-cmp'
    use 'hrsh7th/cmp-nvim-lsp'
    use 'hrsh7th/cmp-vsnip'
    use 'hrsh7th/vim-vsnip'
    use 'hrsh7th/vim-vsnip-integ'
    use 'rafamadriz/friendly-snippets'
    use 'onsails/lspkind-nvim'

    -- Lsp
    use 'neovim/nvim-lspconfig'
    use 'ray-x/lsp_signature.nvim'
    use 'simrat39/symbols-outline.nvim'
    use 'williamboman/nvim-lsp-installer'

    -- Telescope
    -- ripgrep needs to be installed for live_grep and similar picker to work
    use 'nvim-lua/popup.nvim'
    use 'nvim-lua/plenary.nvim'
    use 'nvim-telescope/telescope.nvim'
end)

--{{{1 config of plugins in lua
require('plugin/init')

--{{{1 Mappings
cmd('source ' .. after .. '/keymap/keymappings.vim')
cmd('source ' .. after .. '/keymap/debug.vim')

--{{{1 Color settings
cmd('source ' .. after .. '/colors/color-settings.vim')

--{{{1 Auto commands
cmd('source ' .. after .. '/commands.vim')

--{{{1 Lsp server directory
require('lsps/init')
