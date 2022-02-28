--{{{1 Variables
local cmd           = vim.cmd
local g             = vim.g
local opt           = vim.opt
local fn            = vim.fn
local home          = vim.env.HOME
local config        = home .. '/.config/nvim'
local after         = config .. '/after'
local viml_config   = after .. '/config'
local lua_config    = 'config'


--{{{1 Options
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
  use 'nvim-lua/plenary.nvim'       -- Never uninstall

  use 'romainl/vim-cool'            -- disables search highlighting when you are done searching and re-enables it when you search again.
  use 'christoomey/vim-system-copy' -- Requires xsel
  use 'ap/vim-css-color'
  use 'tpope/vim-surround'
  use 'joom/vim-commentary'
  use 'tpope/vim-repeat'
  use 'andymass/vim-matchup'
  use 'kyazdani42/nvim-web-devicons'
  use 'wellle/targets.vim'
  use 'jiangmiao/auto-pairs'
  use 'nvim-treesitter/nvim-treesitter'
  use 'lukas-reineke/indent-blankline.nvim'
  use 'nvim-lualine/lualine.nvim'
  use 'junegunn/vim-easy-align'
  use 'kyazdani42/nvim-tree.lua'
  use 'karb94/neoscroll.nvim'



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

  -- Lazy loaded plugins
  use {
    'williamboman/nvim-lsp-installer',
    opt = true,
    cmd = { 'LspInstall', 'LspInstallInfo', 'LspInstallLog', 'LspPrintInstalled' },
  }
  use {
    'michaeljsmith/vim-indent-object',
    opt = true,
    ft  = { 'lua' }
  }
  use {
    'junegunn/limelight.vim',
    opt = true,
    cmd = { 'Limelight' }
  }
  use {
    'metakirby5/codi.vim',
    opt = true,
    cmd = { 'Codi' },
    config = 'source ' .. viml_config .. '/codi.vim'
  }
  use {
    'guns/vim-sexp',
    opt = true,
    ft = { 'clojure' },
    config = 'source ' .. viml_config .. '/vim-sexp.vim'
  }
  use {
    'tpope/vim-sexp-mappings-for-regular-people',
    opt = true,
    ft = { 'clojure' },
  }
  use {
    'Olical/conjure',
    opt = true,
    ft = { 'clojure' },
  }
  use {
    'ziglang/zig.vim',
    opt = true,
    ft = { 'zig' },
  }
  use {
    'szw/vim-maximizer',
    opt = true,
    event = {  'WinEnter', 'WinNew' },
  }
  use {
    'TaDaa/vimade',
    opt = true,
    event = {  'WinEnter', 'WinNew' },
    cmd = { 'VimadeBufDisable', 'VimadeToggle' }
  }
  use {
    -- ripgrep needs to be installed for live_grep and similar picker to work
    'nvim-telescope/telescope.nvim',
    opt = true,
    cmd = { 'Telescope' },
    -- requires = {
    -- { 'nvim-lua/popup.nvim', opt = true },
    -- }
  }
  use {
    'puremourning/vimspector',
    opt = true,
    ft = { 'c', 'cpp' },
  }
  use {
    'tpope/vim-fugitive',
    opt = true,
    cmd = { 'Git', 'G' },
  }
  use {
    -- Can't get it to lazy load automatically. Manually loaded in harpoon.lua
    'ThePrimeagen/harpoon',
    opt = true,
  }
  use {
    'simrat39/symbols-outline.nvim',
    opt = true,
    cmd = { 'SymbolsOutline' },
  }
end)

--{{{1 config of plugins in lua
require('plugin')

--{{{1 Mappings
cmd('source ' .. after .. '/keymap/keymappings.vim')
cmd('source ' .. after .. '/keymap/plugin-mappings.vim')
cmd('source ' .. after .. '/keymap/debug.vim')
cmd('source ' .. after .. '/keymap/harpoon.lua')

--{{{1 Color settings
cmd('source ' .. after .. '/colors/color-settings.vim')

--{{{1 Auto commands
cmd('source ' .. after .. '/commands.vim')

--{{{1 Lsp server directory
require('lsps')
