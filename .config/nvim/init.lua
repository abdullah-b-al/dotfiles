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
opt.tabstop        = 4                                              -- Tab width in spaces
opt.softtabstop    = 4                                              -- Tab width in spaces when performing editing operations
opt.shiftwidth     = 4                                              -- Number of spaces to use for each step of (auto)indent
opt.updatetime     = 1000
opt.timeoutlen     = 300

opt.modelineexpr   = true
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
-- opt.foldmethod  = 'expr'
-- opt.foldexpr    = "v:lua.vim.treesitter.foldexpr()"

-- Commands


-- Globals
g.mapleader = ' '
g.maplocalleader = ','


if vim.g.neovide then
    vim.o.guifont = "Ubuntu Mono:h14"
    vim.g.neovide_cursor_animation_length = 0
    vim.g.neovide_scroll_animation_length = 0.25
    vim.g.neovide_cursor_trail_size = 0.05
    vim.g.neovide_refresh_rate_idle = 0
end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
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
    'simrat39/symbols-outline.nvim',
    'ziglang/zig.vim',

    -- color schemes,
    'sainnhe/sonokai',

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
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
})


-- config of plugins in vimscript
cmd('source ' .. viml_config .. '/maximizer.vim')
cmd('source ' .. viml_config .. '/vim-sexp.vim')
cmd('source ' .. viml_config .. '/easy-motion.vim')
cmd('source ' .. viml_config .. '/zig.vim')

-- Color settings
cmd('source ' .. after .. '/colors/color-settings.vim')

-- Auto commands
cmd('source ' .. after .. '/commands.vim')
cmd('colo sonokai')

require("mason").setup()
require('lsp')
require('autocommands')

-- Section: requires
local found_treesitter, configs = pcall(require, "nvim-treesitter.configs")
local found_cmp, cmp = pcall(require, 'cmp')
local found_lspkind, lspkind = pcall(require, 'lspkind')
local found_luasnip, luasnip = pcall(require, 'luasnip')
local found_lualine, lualine = pcall(require, 'lualine')
local found_indent, ibl = pcall(require, "ibl")
local found_gitsigns, gs = pcall(require, 'gitsigns')
local found_autopairs, autopairs = pcall(require, "nvim-autopairs")

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

    vim.keymap.set('i', '<C-u>', 'Cmp: Scroll docs. up')
    vim.keymap.set('i', '<C-d>', 'Cmp: Scroll docs. down')
    vim.keymap.set('i', '<C-e>', 'Cmp: Abort completion')
    vim.keymap.set('i', '<C-c>', 'Cmp: Show completion menu')
    vim.keymap.set('i', '<C-n>', 'Cmp: select next item')
    vim.keymap.set('i', '<C-p>', 'Cmp: select previous item')
    vim.keymap.set('i', '<C-y>', 'Cmp: Confirm selection')
end

-- Section: lua-snip
if found_luasnip then
    local types = require('luasnip.util.types')

    -- Load snippets from friendlysnippets library
    -- require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_lua").lazy_load( { path = vim.env.HOME .. '/.config/nvim/luasnippets/lua.lua' } )
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
    print("Couldn't find luasnip")
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

vim.keymap.set('n', 'g?', ':Telescope keymaps<CR>')

vim.keymap.set('n', '<C-y>', '<C-y><C-y>')
vim.keymap.set('n', '<C-e>', '<C-e><C-e>')
vim.keymap.set('n', '<F12>', ':set spell!<CR>', { silent = true, desc = 'Toggle spell on and off'})
vim.keymap.set('n', '<F5>', ':source ~/.config/nvim/init.lua<CR>', { remap = false , desc = 'Reload init.lua'})
vim.keymap.set('n', '<localleader>,', ':norm ,<CR>', { remap = false, silent = true, desc = 'Map ,, to find previous char without triggering other localleader commands'})
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { remap = false , desc ='Terminal mode setting for NeoVim'})

--{{{1 Substitution
vim.keymap.set('n', '<leader>s', ':%s:\\v::cg<Left><Left><Left><Left>', { remap = false , desc = 'Substitute pattern on whole file'})
vim.keymap.set('v', '<leader>s', ':s:\\v::cg<Left><Left><Left><Left>', { remap = false , desc = 'Substitute pattern on visual selection'})

vim.keymap.set('n', 'gp', '`[v`]', { remap = false, desc = 'Reselect pasted text'})
vim.keymap.set({'n','v'}, 'p', 'mzp`[v`]=`z', { remap = false , desc = 'Format pasted text'})
vim.keymap.set({'n','v'}, 'P', 'mzP`[v`]=`z', { remap = false , desc = 'Format pasted text'})

vim.keymap.set('n', 'Y', 'y$', { remap = false })

vim.keymap.set('n', 'n', 'nzzzv', { remap = false , desc = 'Center the cursor after n'} )
vim.keymap.set('n', 'N', 'Nzzzv', { remap = false , desc = 'Center the cursor after N'} )
vim.keymap.set('n', 'J', 'mzJ`z', { remap = false , desc = 'Center the cursor after J'} )

-- " {{{1 Undo break points
vim.keymap.set('i', ',', ',<C-g>u', { remap = false , desc ='Undo break point at ,'})
vim.keymap.set('i', '.', '.<C-g>u', { remap = false , desc ='Undo break point at .'})
vim.keymap.set('i', '!', '!<C-g>u', { remap = false , desc ='Undo break point at !'})
vim.keymap.set('i', '?', '?<C-g>u', { remap = false , desc ='Undo break point at ?'})

vim.keymap.set('n', '<leader>cl', ':set cursorline!<CR>', { remap = false, silent = true , desc = 'Toggle cursorline'} )
vim.keymap.set('n', '<leader>cc', ':set cursorcolumn!<CR>', { remap = false , silent = true , desc = 'Toggle cursorcolumn'})

-- map('n', '//', '/\\v\\c', { remap = false },
--   'Case insensitive pattern search shortcut')
vim.keymap.set('n', '/', '/\\v', { remap = false , desc = 'Case insensitive pattern search shortcut'})

--{{{1 Center cursor after a half page scroll without polluting the jump list
-- map('n', '<C-d>', '<C-d>zz', { remap = false })
-- map('n', '<C-u>', '<C-u>zz', { remap = false })

vim.keymap.set('n', '_', '"_', { desc = 'Quicker access to the black hole register'})

--{{{1 quickfix mappings
vim.keymap.set('n', '<C-l>', ':cnext<CR>zv', { remap = false , desc = 'Go to next item in quickfix list'})
vim.keymap.set('n', '<C-h>', ':cprev<CR>zv', { remap = false , desc = 'Go to prev item in quickfix list'})
vim.keymap.set('n', '<C-q>', ':copen<CR>', { remap = false , desc = 'Open quickfix list'})
vim.keymap.set('n', '<C-Space><C-l>', ':lnext<CR>zv', { remap = false , desc = 'Go to next item in local quickfix list'})
vim.keymap.set('n', '<C-Space><C-h>', ':lprev<CR>zv', { remap = false , desc = 'Go to prev item in local quickfix list'})
vim.keymap.set('n', '<C-Space><C-q>', ':lopen<CR>', { remap = false , desc = 'Open local quickfix list'})
vim.keymap.set('n', '<C-c><C-q>', ':cclose<CR>:lclose<CR>', { remap = false, silent = true , desc = 'Close quickfix lists'})

-- map('n', 'q:', ':', { remap = false },
--   'Map the annoying q: to :' )
vim.keymap.set('n', 'Q', ':', { remap = false })

-- " {{{1 Nicer tab switching
vim.keymap.set('n', '<leader>1', '1gt', { remap = false, silent = true })
vim.keymap.set('n', '<leader>2', '2gt', { remap = false, silent = true })
vim.keymap.set('n', '<leader>3', '3gt', { remap = false, silent = true })
vim.keymap.set('n', '<leader>4', '4gt', { remap = false, silent = true })
vim.keymap.set('n', '<leader>5', '5gt', { remap = false, silent = true })

-- Cut and replace
vim.keymap.set('n', '<leader>vw', 'viwp')
vim.keymap.set('n', '<leader>vW', 'viWp')
vim.keymap.set('n', '<leader>v"', 'vi"p')
vim.keymap.set('n', "<leader>v'", "vi'p")
vim.keymap.set('n', '<leader>v)', 'vi)p')
vim.keymap.set('n', '<leader>v}', 'vi}p')
vim.keymap.set('n', '<leader>v]', 'vi]p')

-- call :nohl
vim.keymap.set('n', 'l', 'l<cmd>nohl<CR>', { remap = false })
vim.keymap.set('n', 'h', 'h<cmd>nohl<CR>', { remap = false })
vim.keymap.set('n', 'k', [[(v:count >= 5 ? "m'" . v:count : '') . 'gk<cmd>nohl<CR>']], { remap = false, expr = true , desc ='Add large j movements to the jump list and call :nohl'})
vim.keymap.set('n', 'j', [[(v:count >= 5 ? "m'" . v:count : '') . 'gj<cmd>nohl<CR>']], { remap = false, expr = true , desc ='Add large k movements to the jump list and call :nohl'})

-- Section: plugin mappings
-- Telescope
vim.keymap.set('n', '<leader>ff', ':Telescope find_files<CR>', { remap = false })
vim.keymap.set('n', '<leader>fg', ':Telescope live_grep<CR>' , { remap = false })
vim.keymap.set('n', '<leader>fb', ':Telescope buffers<CR>'   , { remap = false })
vim.keymap.set('n', '<leader>fh', ':Telescope help_tags<CR>' , { remap = false })

-- easy motion

-- Global mapping
vim.keymap.set('n', '<leader>;', '<Plug>(easymotion-next)')
vim.keymap.set('n', '<leader>,', '<Plug>(easymotion-prev)')

-- Multi line
vim.keymap.set('n', 's', '<Plug>(easymotion-bd-f)')

-- Multi line Overwindows
vim.keymap.set('n', '<leader>wl', '<Plug>(easymotion-overwin-line)')

-- surround.vim
vim.keymap.set('n', 'S', '<Plug>Ysurround')
-- fugitive
vim.keymap.set('n', '<F1>', ':tab Git<CR>', { remap = false, silent = true  })
-- vim-maximizer
vim.keymap.set('n', '<C-w><CR>', ':MaximizerToggle<CR>', { remap = false })
-- vim-easy-align
vim.keymap.set('v', 'ga', ':EasyAlign<CR>')
-- SymbolsOutline
vim.keymap.set('n', '<leader>ol', ':SymbolsOutline<CR>', { remap = false })
-- Gitsings
vim.keymap.set('n', '<leader>hp', '<cmd>Gitsigns preview_hunk<CR>', { remap = false , desc = 'Gitsigns: Preview hunk'})
vim.keymap.set('n', '<leader>n', '<cmd>Gitsigns next_hunk<CR>', { remap = false , desc = 'Gitsigns: Go to next hunk'})
vim.keymap.set('n', '<leader>p', '<cmd>Gitsigns next_hunk<CR>', { remap = false , desc = 'Gitsigns: Go to previous hunk'})
-- LuaSnip
vim.keymap.set({'i','s'}, '<C-l>', function() require('luasnip').jumpable(1) end, { desc =  'LuaSnip: Jump forward'})
vim.keymap.set({'i','s'}, '<C-h>', function() require('luasnip').jumpable(-1) end, {  desc = 'LuaSnip: Jump backword'})
vim.keymap.set({'i', 's'}, "<C-k>", function ()
    if require('luasnip').expand_or_jumpable() then
        require('luasnip').expand_or_jump()
    end
end, {silent = true, desc = 'LuaSnip: jump or expand'})
