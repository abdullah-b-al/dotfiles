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
opt.ignorecase     = true
opt.smartcase      = true
opt.foldenable     = false

opt.wrap           = false

opt.dictionary     = opt.dictionary + '/usr/share/dict/words'
opt.spellfile      = home .. '/.local/share/nvim/spell/en.utf-8.add'
opt.viewoptions    = 'cursor'                                 -- save/restore just these with {mk,load}view`

opt.foldmethod     = 'manual'
-- opt.foldmethod     = 'expr'
-- opt.foldexpr       = 'nvim_treesitter#foldexpr()'

-- Commands


-- Globals
g.mapleader = ' '
g.maplocalleader = ','


if vim.g.neovide then
  vim.o.guifont = "Ubuntu Mono:h14"
vim.g.neovide_cursor_animation_length = 0
end


pl = require('plugin-manager')

-- Plugins
pl.plugins = {
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
  'lewis6991/gitsigns.nvim',
  'szw/vim-maximizer',
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
  'hrsh7th/cmp-path',
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
require('Mappings')

-- config of plugins in vimscript
cmd('source ' .. viml_config .. '/mini-map.vim')
cmd('source ' .. viml_config .. '/maximizer.vim')
cmd('source ' .. viml_config .. '/vim-sexp.vim')
cmd('source ' .. viml_config .. '/easy-motion.vim')
cmd('source ' .. viml_config .. '/zig.vim')

-- Color settings
cmd('source ' .. after .. '/colors/color-settings.vim')

-- Auto commands
cmd('source ' .. after .. '/commands.vim')
cmd('colo sonokai')

-- Lsp server directory
require('lsps')

require('autocommands')
require('project-settings')

-- Section: requires
local found_treesitter, configs = pcall(require, "nvim-treesitter.configs")
local found_cmp, cmp = pcall(require, 'cmp')
local found_lspkind, lspkind = pcall(require, 'lspkind')
local found_luasnip, luasnip = pcall(require, 'luasnip')
local found_lualine, lualine = pcall(require, 'lualine')
local found_indent, ibl = pcall(require, "ibl")
local found_gitsigns, gs = pcall(require, 'gitsigns')
local found_autopairs, autopairs = pcall(require, "nvim-autopairs")
local map = _G.Mappings.map

-- Section: treesiteer
if found_treesitter then
  configs.setup {
    ensure_installed = {
      'c',
      'cpp',
      'lua',
      'make',
      'vim',
      'zig',
    },

    sync_install = false,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },

    indent = { enable = true },
  }
else
  print("Couldn't find treesitter in tree-sitter.lua")
end


-- Section: nvim-cmp
if found_cmp and found_lspkind and found_luasnip then
  vim.opt.completeopt = {'menuone', 'preview'}

  cmp.setup({
    experimental = {
      ghost_text = true,
    },
    completion = {
      keyword_length = 2,
    },
    snippet = {
      expand = function(args)
        luasnip.lsp_expand(args.body)
      end
    },
    mapping = {
      ['<C-u>'] = cmp.mapping.scroll_docs(-4),
      ['<C-d>'] = cmp.mapping.scroll_docs(4),
      ['<C-e>'] = cmp.mapping.abort(),       -- Close menu and reject selection
      ['<C-c>'] = cmp.mapping.complete(),
      ['<C-n>'] = cmp.mapping.select_next_item( { behavior = cmp.SelectBehavior.Select }),
      ['<C-p>'] = cmp.mapping.select_prev_item( { behavior = cmp.SelectBehavior.Select }),
      ['<C-y>'] = cmp.mapping.confirm(),
    },
    sources = {
      { name = 'nvim_lsp' },
      { name = 'luasnip' },
      { name = 'path' },
      
    },
    formatting = {
      format = lspkind.cmp_format({
        with_text = true,
        mode = 'text',
        menu = {
          buffer   = '[BUF]',
          nvim_lsp = '[LSP]',
          vsnip    = '[VSNIP]',
        },
      })
    },
  })

  vim.opt.pumheight = 10

  _G.Mappings.add({'i'}, '<C-u>', 'Cmp: Scroll docs. up')
  _G.Mappings.add({'i'}, '<C-d>', 'Cmp: Scroll docs. down')
  _G.Mappings.add({'i'}, '<C-e>', 'Cmp: Abort completion')
  _G.Mappings.add({'i'}, '<C-c>', 'Cmp: Show completion menu')
  _G.Mappings.add({'i'}, '<C-n>', 'Cmp: select next item')
  _G.Mappings.add({'i'}, '<C-p>', 'Cmp: select previous item')
  _G.Mappings.add({'i'}, '<C-y>', 'Cmp: Confirm selection')
end

-- Section: lua-snip
if not found_luasnip then
  local types = require('luasnip.util.types')

  -- Load snippets from friendlysnippets library
  -- require("luasnip.loaders.from_vscode").lazy_load()
  require("luasnip.loaders.from_lua").lazy_load( { path = vim.env.HOME .. '/.config/nvim/luasnippets/zig.lua' } )
  luasnip.config.set_config {
    history = true,

    update_events = 'TextChanged, TextChangedI',

    enable_autosnippets = true,

    ext_opts = {
      [types.choiceNode] = {
        active = {
          virt_text = { { '<-', 'Error' } },
        },
      },
    },
  }

  -- load custom snippets
else
  print("Couldn't find luasnip in lua-snip.lua")
end



-- Section: auto-pairs
if found_autopairs then
  autopairs.setup({
    check_ts = true,
    ts_config = {
      lua = {'string'},-- it will not add a pair on that treesitter node
    }
  })

else
  print ("Couldn't find autopairs in autopairs.lua")
end

-- Section: cmp
if found_cmp then
  local cmp_auto_pairs = require('nvim-autopairs.completion.cmp')
  cmp.event:on("confirm_done", cmp_auto_pairs.on_confirm_done( {map_char = { tex = ""}} ) )
else
  print("Couldn't find cmp in autopairs.lua")
end

-- Section: Gitsigns
if found_gitsigns then
  gs.setup {
    signs = {
      add = { hl = "GitSignsAdd", text = "▎", numhl = "GitSignsAddNr", linehl = "GitSignsAddLn" },
      change = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
      delete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      topdelete = { hl = "GitSignsDelete", text = "契", numhl = "GitSignsDeleteNr", linehl = "GitSignsDeleteLn" },
      changedelete = { hl = "GitSignsChange", text = "▎", numhl = "GitSignsChangeNr", linehl = "GitSignsChangeLn" },
    },
    signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
    numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
    linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
    word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
    watch_gitdir = {
      interval = 1000,
      follow_files = true,
    },
    attach_to_untracked = true,
    current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
      delay = 1000,
      ignore_whitespace = false,
    },
    current_line_blame_formatter_opts = {
      relative_time = false,
    },
    sign_priority = 6,
    update_debounce = 100,
    status_formatter = nil, -- Use default
    max_file_length = 40000,
    preview_config = {
      -- Options passed to nvim_open_win
      border = "single",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
    yadm = {
      enable = false,
    },
  }
else
  print("Couldn't find gitsigns in gitsigns.lua")
end

-- Section: indent-line
if found_indent then
  ibl.setup {}
else
  print("Couldn't find indent_blankline in indent-line.lua")
end

-- Section: lua-line
if found_lualine then
  -- Color table for highlights
  -- stylua: ignore
  local colors = {
    bg       = '#202328',
    fg       = '#bbc2cf',
    yellow   = '#ECBE7B',
    cyan     = '#008080',
    darkblue = '#081633',
    green    = '#98be65',
    orange   = '#FF8800',
    violet   = '#a9a1e1',
    magenta  = '#c678dd',
    blue     = '#51afef',
    red      = '#ec5f67',
  }

  local conditions = {
    buffer_not_empty = function()
      return vim.fn.empty(vim.fn.expand '%:t') ~= 1
    end,
    hide_in_width = function()
      return vim.fn.winwidth(0) > 80
    end,
    check_git_workspace = function()
      local filepath = vim.fn.expand '%:p:h'
      local gitdir = vim.fn.finddir('.git', filepath .. ';')
      return gitdir and #gitdir > 0 and #gitdir < #filepath
    end,
  }

  -- Config
  local config = {
    options = {
      -- Disable sections and component separators
      component_separators = '',
      section_separators = '',
      globalstatus = true,
      theme = {
        -- We are going to use lualine_c an lualine_x as left and
        -- right section. Both are highlighted by c theme .  So we
        -- are just setting default looks o statusline
        normal = { c = { fg = colors.fg, bg = colors.bg } },
        inactive = { c = { fg = colors.fg, bg = colors.bg } },
      },
    },
    sections = {
      -- these are to remove the defaults
      lualine_a = {},
      lualine_b = {},
      lualine_y = {},
      lualine_z = {},
      -- These will be filled later
      lualine_c = {},
      lualine_x = {},
    },
    inactive_sections = {
      -- these are to remove the defaults
      lualine_a = {},
      lualine_v = {},
      lualine_y = {},
      lualine_z = {},
      lualine_c = {},
      lualine_x = {},
    },
  }

  -- Inserts a component in lualine_c at left section
  local function ins_left(component)
    table.insert(config.sections.lualine_c, component)
  end

  -- Inserts a component in lualine_x ot right section
  local function ins_right(component)
    table.insert(config.sections.lualine_x, component)
  end

  ins_left {
    function()
      return '▊'
    end,
    color = { fg = colors.blue }, -- Sets highlighting of component
    padding = { left = 0, right = 1 }, -- We don't need space before this
  }

  ins_left {
    -- mode component
    function()
      -- auto change color according to neovims mode
      local mode_color = {
        n = colors.red,
        i = colors.green,
        v = colors.blue,
        [''] = colors.blue,
        V = colors.blue,
        c = colors.magenta,
        no = colors.red,
        s = colors.orange,
        S = colors.orange,
        [''] = colors.orange,
        ic = colors.yellow,
        R = colors.violet,
        Rv = colors.violet,
        cv = colors.red,
        ce = colors.red,
        r = colors.cyan,
        rm = colors.cyan,
        ['r?'] = colors.cyan,
        ['!'] = colors.red,
        t = colors.red,
      }
      vim.api.nvim_command('hi! LualineMode guifg=' .. mode_color[vim.fn.mode()] .. ' guibg=' .. colors.bg)

      local modes = { i = 'Insert', n = 'Normal', v = 'Visual', V = 'Visual Line', c = 'Command', t = 'Terminal' }
      return modes[vim.fn.mode()] or vim.fn.mode()
    end,
    color = 'LualineMode',
    padding = { right = 1 },
  }

  ins_left {
    'filesize',
    cond = conditions.buffer_not_empty,
  }

  ins_left {
    'filename',
    cond = conditions.buffer_not_empty,
    color = { fg = colors.magenta, gui = 'bold' },
  }

  ins_left {
    'diagnostics',
    sources = { 'nvim_diagnostic' },
    symbols = { error = ' ', warn = ' ', info = ' ' },
    diagnostics_color = {
      color_error = { fg = colors.red },
      color_warn = { fg = colors.yellow },
      color_info = { fg = colors.cyan },
    },
  }

  -- Insert mid section. You can make any number of sections in neovim :)
  -- for lualine it's any number greater then 2
  ins_left {
    function()
      return '%='
    end,
  }

  ins_left {
    -- Lsp server name .
    function()
      local msg = 'No Active Lsp'
      local buf_ft = vim.api.nvim_buf_get_option(0, 'filetype')
      local clients = vim.lsp.get_active_clients()
      if next(clients) == nil then
        return msg
      end
      for _, client in ipairs(clients) do
        local filetypes = client.config.filetypes
        if filetypes and vim.fn.index(filetypes, buf_ft) ~= -1 then
          return client.name
        end
      end
      return msg
    end,
    icon = '  LSP:',
    color = { fg = '#ffffff', gui = 'bold' },
  }

  ins_right { 'location' }

  ins_right { 'progress', color = { fg = colors.fg, gui = 'bold' } }

  ins_right {
    'filetype',
  }

  -- Add components to right sections
  ins_right {
    'o:encoding', -- option component same as &encoding in viml
    fmt = string.upper, -- I'm not sure why it's upper case either ;)
    cond = conditions.hide_in_width,
    color = { fg = colors.green, gui = 'bold' },
  }

  ins_right {
    'branch',
    icon = '',
    color = { fg = colors.violet, gui = 'bold' },
  }

  ins_right {
    'diff',
    -- Is it me or the symbol for modified us really weird
    symbols = { added = ' ', modified = '柳 ', removed = ' ' },
    diff_color = {
      added = { fg = colors.green },
      modified = { fg = colors.orange },
      removed = { fg = colors.red },
    },
    cond = conditions.hide_in_width,
  }

  ins_right {
    function()
      return '▊'
    end,
    color = { fg = colors.blue },
    padding = { left = 1 },
  }

  -- Now don't forget to initialize lualine
  lualine.setup(config)
else
  print("Couldn't find lualine in lua-line.lua")
end

-- Section:

-- Section: Mappings
map({'n'}, 'g?', _G.Mappings.view, { noremap = true, silent = true},
  'View this cheat sheet')

map({'n'}, '<F12>', ':set spell!<CR>', { silent = true},
  'Toggle spell on and off')

--{{{1 Resource init.lua
map({'n'}, '<F5>', ':source ~/.config/nvim/init.lua<CR>', { noremap = true },
  'Reload init.lua')

map({'n'}, '<localleader>,', ':norm ,<CR>', { noremap = true, silent = true},
  'Map ,, to find previous char without triggering other localleader commands')

map({'t'}, '<Esc><Esc>', '<C-\\><C-n>', { noremap = true },
  'Terminal mode setting for NeoVim')

--{{{1 Substitution
map({'n'}, '<leader>s', ':%s:\\v::cg<Left><Left><Left><Left>', { noremap = true },
  'Substitute pattern on whole file')
map({'v'}, '<leader>s', ':s:\\v::cg<Left><Left><Left><Left>', { noremap = true },
  'Substitute pattern on visual selection')

map({'n'}, 'gp', '`[v`]', { noremap = true },
  'Reselect pasted text')
map({'n','v'}, 'p', 'mzp`[v`]=`z', { noremap = true },
  'Format pasted text')
map({'n','v'}, 'P', 'mzP`[v`]=`z', { noremap = true },
  'Format pasted text')

map({'n'}, 'Y', 'y$', { noremap = true },
  'Yank till end of line')

map({'n'}, 'n', 'nzzzv', { noremap = true },
  'Center the cursor after n')
map({'n'}, 'N', 'Nzzzv', { noremap = true },
  'Center the cursor after N')
map({'n'}, 'J', 'mzJ`z', { noremap = true },
  'Center the cursor after J')

-- " {{{1 Undo break points
map({'i'}, ',', ',<C-g>u', { noremap = true },
  'Undo break point at ,')
map({'i'}, '.', '.<C-g>u', { noremap = true },
  'Undo break point at .')
map({'i'}, '!', '!<C-g>u', { noremap = true },
  'Undo break point at !')
map({'i'}, '?', '?<C-g>u', { noremap = true },
  'Undo break point at ?')

map({'n'}, '<leader>cl', ':set cursorline!<CR>', { noremap = true, silent = true },
  'Toggle cursorline')
map({'n'}, '<leader>cc', ':set cursorcolumn!<CR>', { noremap = true , silent = true},
  'Toggle cursorcolumn')

-- map({'n'}, '//', '/\\v\\c', { noremap = true },
--   'Case insensitive pattern search shortcut')
map({'n'}, '/', '/\\v', { noremap = true },
  'Case insensitive pattern search shortcut')

--{{{1 Center cursor after a half page scroll without polluting the jump list
-- map({'n'}, '<C-d>', '<C-d>zz', { noremap = true })
-- map({'n'}, '<C-u>', '<C-u>zz', { noremap = true })

map({'n'}, '_', '"_', {},
  'Quicker access to the black hole register')

--{{{1 quickfix mappings
map({'n'}, '<C-l>', ':cnext<CR>zv', { noremap = true },
  'Go to next item in quickfix list')
map({'n'}, '<C-h>', ':cprev<CR>zv', { noremap = true },
  'Go to prev item in quickfix list')
map({'n'}, '<C-q>', ':copen<CR>', { noremap = true },
  'Open quickfix list')
map({'n'}, '<C-Space><C-l>', ':lnext<CR>zv', { noremap = true },
  'Go to next item in local quickfix list')
map({'n'}, '<C-Space><C-h>', ':lprev<CR>zv', { noremap = true },
  'Go to prev item in local quickfix list')
map({'n'}, '<C-Space><C-q>', ':lopen<CR>', { noremap = true },
  'Open local quickfix list')
map({'n'}, '<C-c><C-q>', ':cclose<CR>:lclose<CR>', { noremap = true, silent = true },
  'Close quickfix lists')

-- map({'n'}, 'q:', ':', { noremap = true },
--   'Map the annoying q: to :' )
map({'n'}, 'Q', ':', { noremap = true },
  'Map Q to :')

-- " {{{1 Nicer tab switching
map({'n'}, '<leader>1', '1gt', { noremap = true, silent = true },
  'Move to tab 1')
map({'n'}, '<leader>2', '2gt', { noremap = true, silent = true },
  'Move to tab 2')
map({'n'}, '<leader>3', '3gt', { noremap = true, silent = true },
  'Move to tab 3')
map({'n'}, '<leader>4', '4gt', { noremap = true, silent = true },
  'Move to tab 4')
map({'n'}, '<leader>5', '5gt', { noremap = true, silent = true },
  'Move to tab 5')

-- Cut and replace
map({'n'}, '<leader>vw', 'viwp', {},
  'Replace inside word')
map({'n'}, '<leader>vW', 'viWp', {},
  'Replace inside WORD')
map({'n'}, '<leader>v"', 'vi"p', {},
  'Replace inside "')
map({'n'}, "<leader>v'", "vi'p", {},
  "Replace inside '")
map({'n'}, '<leader>v)', 'vi)p', {},
  'Replace inside )')
map({'n'}, '<leader>v}', 'vi}p', {},
  'Replace inside }')
map({'n'}, '<leader>v]', 'vi]p', {},
  'Replace inside ]')

-- Center cursor after jump list movement
-- map({'n'}, '<C-i>', '<C-i>zz', { noremap = true },
--   'Center cursor after jump list movement')
-- map({'n'}, '<C-o>', '<C-o>zz', { noremap = true },
--   'Center cursor after jump list movement')

-- call :nohl
map({'n'}, 'l', 'l<cmd>nohl<CR>', { noremap = true },
  'call :nohl after movement')
map({'n'}, 'h', 'h<cmd>nohl<CR>', { noremap = true },
  'call :nohl after movement')
map({'n'}, 'k', [[(v:count >= 5 ? "m'" . v:count : '') . 'gk<cmd>nohl<CR>']], { noremap = true, expr = true},
  'Add large j movements to the jump list and call :nohl')
map({'n'}, 'j', [[(v:count >= 5 ? "m'" . v:count : '') . 'gj<cmd>nohl<CR>']], { noremap = true, expr = true},
  'Add large k movements to the jump list and call :nohl')

-- Section: plugin mappings
-- Telescope
map({'n'}, '<leader>ff', ':Telescope find_files<CR>', { noremap = true },
  'Telescope: find files')
map({'n'}, '<leader>fg', ':Telescope live_grep<CR>' , { noremap = true },
  'Telescope: grep cwd')
map({'n'}, '<leader>fb', ':Telescope buffers<CR>'   , { noremap = true },
  'Telescope: Show buffers')
map({'n'}, '<leader>fh', ':Telescope help_tags<CR>' , { noremap = true },
  'Telescope: Show help tage')

-- easy motion

-- Global mapping
map({'n'}, '<leader>;', '<Plug>(easymotion-next)', {},
  'EasyMotion: Next char')
map({'n'}, '<leader>,', '<Plug>(easymotion-prev)', {},
  'EasyMotion: Prev char')

-- Multi line
map({'n'}, 's', '<Plug>(easymotion-bd-f)' , {},
  'EasyMotion: Find char')
-- map({'n'}, 's',         '<Plug>(easymotion-s2)'   , {},
--   'EasyMotion: Till 2-chars')

-- Multi line Overwindows
map({'n'}, '<leader>wl', '<Plug>(easymotion-overwin-line)', {},
  'EasyMotion: Find char over-window')

-- surround.vim
map({'n'}, 'S', '<Plug>Ysurround', {},
  'Surround')
-- fugitive
map({'n'}, '<F1>', ':tab Git<CR>', { noremap = true, silent = true  },
  'Fugitive: Open in tab')
-- vim-maximizer
map({'n'}, '<C-w><CR>', ':MaximizerToggle<CR>', { noremap = true },
  'Maximizer: Toggle')
-- vim-easy-align
map({'v'}, 'ga', ':EasyAlign<CR>', {},
  'EasyAlign')
-- SymbolsOutline
map({'n'}, '<leader>ol', ':SymbolsOutline<CR>', { noremap = true },
  'SymbolsOutline: Toggle')
-- Gitsings
map({'n'}, '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>', { noremap = true },
  'Gitsigns: Preview hunk')
map({'n'}, '<leader>n', '<cmd>Gitsigns next_hunk<CR>', { noremap = true },
  'Gitsigns: Go to next hunk')
map({'n'}, '<leader>p', '<cmd>Gitsigns next_hunk<CR>', { noremap = true },
  'Gitsigns: Go to previous hunk')
-- LuaSnip
map({'i','s'}, '<C-l>', function() require('luasnip').jumpable(1) end, {},
  'LuaSnip: Jump forward')
map({'i','s'}, '<C-h>', function() require('luasnip').jumpable(-1) end, {},
  'LuaSnip: Jump backword')
map({'i', 's'}, "<C-k>", function ()
  if require('luasnip').expand_or_jumpable() then
    require('luasnip').expand_or_jump()
  end
end, {silent = true}, 'LuaSnip: jump or expand')

--  Harpoon
map({'n'}, '<leader>gg', require("harpoon.ui").toggle_quick_menu, {} ,
  'Harpoon: Open window')
map({'n'}, '<leader>ga', require("harpoon.mark").add_file, {},
  'Harpoon: Add file')
map({'n'}, '<leader>gn', function() require("harpoon.ui").nav_file(1) end, {},
  'Harpoon: Navigate to mark 1')
map({'n'}, '<leader>ge', function() require("harpoon.ui").nav_file(2) end, {},
  'Harpoon: Navigate to mark 2')
map({'n'}, '<leader>gi', function() require("harpoon.ui").nav_file(3) end, {},
  'Harpoon: Navigate to mark 3')

-- mini-map
map({'n'}, '<leader>mm',
  function()
    vim.cmd[[
  MinimapToggle
  MinimapRefresh
  ]]
  end,
  { noremap = true, silent = true },
  'Toggle minimap')
