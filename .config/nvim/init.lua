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
cmd 'packadd packer.nvim'


-- Globals
g.mapleader = ' '
g.maplocalleader = ','

-- Plugins
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
  use 'nvim-lua/plenary.nvim'       -- Never uninstall

  use 'nvim-telescope/telescope.nvim'
  use 'romainl/vim-cool'            -- disables search highlighting when you are done searching and re-enables it when you search again.
  use 'christoomey/vim-system-copy' -- Requires xsel
  use 'ap/vim-css-color'
  use 'tpope/vim-surround'
  use 'joom/vim-commentary'
  use 'tpope/vim-repeat'
  use 'andymass/vim-matchup'
  use 'kyazdani42/nvim-web-devicons'
  use 'wellle/targets.vim'
  use 'windwp/nvim-autopairs'
  use 'nvim-treesitter/nvim-treesitter'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'nvim-lualine/lualine.nvim'
  use 'junegunn/vim-easy-align'
  use 'kyazdani42/nvim-tree.lua'
  use 'lewis6991/gitsigns.nvim'
  use 'mickael-menu/zk-nvim'
  use 'wfxr/minimap.vim'
  use 'szw/vim-maximizer'
  use 'michaeljsmith/vim-indent-object'
  use 'junegunn/limelight.vim'
  use 'metakirby5/codi.vim'
  use 'guns/vim-sexp'
  use 'tpope/vim-sexp-mappings-for-regular-people'
  use 'Olical/conjure'
  use 'ziglang/zig.vim'
  use 'tpope/vim-fugitive'
  use 'ThePrimeagen/harpoon'
  use 'simrat39/symbols-outline.nvim'

  -- color schemes
  use 'ellisonleao/gruvbox.nvim'
  use 'sainnhe/sonokai'
  use 'sainnhe/edge'
  use 'Th3Whit3Wolf/space-nvim'
  use 'andersevenrud/nordic.nvim'
  use 'marko-cerovac/material.nvim'
  use 'RRethy/nvim-base16'
  use 'shaunsingh/nord.nvim'

  -- Movement plugins
  use 'easymotion/vim-easymotion'
  use 'unblevable/quick-scope'

  -- Completion and snippets
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'
  use 'L3MON4D3/LuaSnip'
  use 'saadparwaiz1/cmp_luasnip'
  use 'rafamadriz/friendly-snippets'
  use 'onsails/lspkind-nvim'

  -- Lsp
  use 'neovim/nvim-lspconfig'
  use 'ray-x/lsp_signature.nvim'
  use 'williamboman/nvim-lsp-installer'
end)

-- Global mapping table and functions
require('keymap/Mappings')

-- config of plugins in lua
require('plugin')

-- Mappings
require('keymap')

-- config of plugins in vimscript
cmd('source ' .. viml_config .. '/mini-map.vim')
cmd('source ' .. viml_config .. '/maximizer.vim')
cmd('source ' .. viml_config .. '/codi.vim')
cmd('source ' .. viml_config .. '/vim-sexp.vim')

-- Color settings
cmd('source ' .. after .. '/colors/color-settings.vim')

-- Auto commands
cmd('source ' .. after .. '/commands.vim')

-- Lsp server directory
require('lsps')

require('project-settings')
