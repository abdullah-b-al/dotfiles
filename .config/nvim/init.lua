-- Variables
local cmd           = vim.cmd
local g             = vim.g
local opt           = vim.opt
local fn            = vim.fn
local home          = vim.env.HOME
local config        = home .. '/.config/nvim'
local after         = config .. '/after'
local viml_config   = after .. '/config'
local lua_config    = 'config'


-- Options
opt.tabstop        = 2                                              -- Tab width in spaces
opt.softtabstop    = 2                                              -- Tab width in spaces when performing editing operations
opt.shiftwidth     = 2                                              -- Number of spaces to use for each step of (auto)indent
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
opt.viewoptions    = 'cursor'                                 -- save/restore just these with {mk,load}view`

opt.foldmethod     = 'expr'
opt.foldexpr       = 'nvim_treesitter#foldexpr()'

-- Commands


-- Globals
g.mapleader = ' '
g.maplocalleader = ','

-- Plugins
require('plugin-manager').plugins = {
  -- use 'wbthomason/packer.nvim'
  'nvim-lua/plenary.nvim',       -- Never uninstall

  'nvim-telescope/telescope.nvim',
  'christoomey/vim-system-copy', -- Requires xsel
  'ap/vim-css-color',
  'tpope/vim-surround',
  'joom/vim-commentary',
  'tpope/vim-repeat',
  'andymass/vim-matchup',
  'kyazdani42/nvim-web-devicons',
  'wellle/targets.vim',
  'windwp/nvim-autopairs',
  'nvim-treesitter/nvim-treesitter',
  'lukas-reineke/indent-blankline.nvim',
  'nvim-lualine/lualine.nvim',
  'junegunn/vim-easy-align',
  'kyazdani42/nvim-tree.lua',
  'lewis6991/gitsigns.nvim',
  'mickael-menu/zk-nvim',
  'wfxr/minimap.vim',
  'szw/vim-maximizer',
  'guns/vim-sexp',
  'tpope/vim-sexp-mappings-for-regular-people',
  'Olical/conjure',
  'tpope/vim-fugitive',
  'ThePrimeagen/harpoon',
  'simrat39/symbols-outline.nvim',
  'ziglang/zig.vim',

  -- color schemes,
  'ellisonleao/gruvbox.nvim',
  'sainnhe/sonokai',
  'sainnhe/edge',
  'Th3Whit3Wolf/space-nvim',
  'andersevenrud/nordic.nvim',
  'marko-cerovac/material.nvim',
  'RRethy/nvim-base16',
  'shaunsingh/nord.nvim',

  -- Movement plugins,
  'easymotion/vim-easymotion',
  'unblevable/quick-scope',

  -- Completion and snippets,
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-nvim-lsp',
  'L3MON4D3/LuaSnip',
  'saadparwaiz1/cmp_luasnip',
  'rafamadriz/friendly-snippets',
  'onsails/lspkind-nvim',

  -- Lsp,
  'neovim/nvim-lspconfig',
  'ray-x/lsp_signature.nvim',
  'williamboman/nvim-lsp-installer',
}

-- Global mapping table and functions
require('keymap/Mappings')

-- config of plugins in lua
require('plugin')

-- Mappings
require('keymap')

-- config of plugins in vimscript
cmd('source ' .. viml_config .. '/mini-map.vim')
cmd('source ' .. viml_config .. '/maximizer.vim')
cmd('source ' .. viml_config .. '/vim-sexp.vim')

-- Color settings
cmd('source ' .. after .. '/colors/color-settings.vim')

-- Auto commands
cmd('source ' .. after .. '/commands.vim')

-- Lsp server directory
require('lsps')

require('autocommands')
require('project-settings')
