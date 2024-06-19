-- vim: foldmethod=expr foldnestmax=1 nofoldenable
-- Variables
local cmd           = vim.cmd
local g             = vim.g
local opt           = vim.opt
local home          = vim.env.HOME

if vim.loader then
    vim.loader.enable()
end

function Unique_map(modes, lhs, rhs, opts)
    if not opts then opts = {} end
    if opts.unique == nil then
        local keys_to_ignore = {'<C-l>' }
        local ignore = false
        for _, v in ipairs(keys_to_ignore) do
            if (lhs == v) then
                ignore = true
                break
            end
        end

        local make_unique = false -- Set to true when testing for conflicting maps
        if make_unique and not ignore then
            opts.unique = true
        end
    end
    vim.keymap.set(modes, lhs, rhs, opts)
end

-- Options
opt.tabstop        = 4                                              -- Tab width in spaces
opt.softtabstop    = 4                                              -- Tab width in spaces when performing editing operations
opt.shiftwidth     = 4                                              -- Number of spaces to use for each step of (auto)indent
opt.updatetime     = 1000
opt.timeoutlen     = 300
opt.colorcolumn    = {80}

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
opt.foldexpr    = "v:lua.vim.treesitter.foldexpr()"

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


-- Auto commands
cmd('source ' .. vim.env.HOME .. '/.config/nvim/after/commands.vim')

-- Section: Auto commands
-- Disable colorcolumn for certain file types
vim.api.nvim_create_autocmd( {"FileType"}, {
    pattern = {"*.markdown", "*.txt", "*.netrw"},
    callback = function () vim.cmd('set colorcolumn=0') end
})

vim.api.nvim_create_autocmd( {"BufWinEnter"}, {
    callback = function ()
        require("per-project-settings").apply(0)
    end,
})

vim.api.nvim_create_autocmd( {"vimenter", "ColorScheme"}, {
    pattern = {"*"},
    callback = function ()
        vim.cmd('highlight! MatchParen guifg=#FF0000 guibg=#202020 gui=NONE ctermfg=196 ctermbg=233 cterm=reverse')
        vim.cmd('hi! VM_Mono guibg=#CC1111 guifg=Black gui=NONE')
    end
})


-- Section: Mappings
Unique_map('n', '<F5>', function ()
    vim.cmd("source ~/.config/nvim/init.lua")
    package.loaded["per-project-settings"] = nil -- For force reloading
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        require("per-project-settings").apply(bufnr)
    end
end, { remap = false , desc = 'Reload init.lua'})

Unique_map({'n', 'v'}, '<C-y>', '<C-y><C-y>')
Unique_map({'n', 'v'}, '<C-e>', '<C-e><C-e>')
Unique_map('n', '<F12>', ':set spell!<CR>', { silent = true, desc = 'Toggle spell on and off'})
Unique_map('n', '<localleader>,', ':norm ,<CR>', { remap = false, silent = true, desc = 'Map ,, to find previous char without triggering other localleader commands'})
Unique_map('t', '<Esc><Esc>', '<C-\\><C-n>', { remap = false , desc ='Terminal mode setting for NeoVim'})

--{{{1 Substitution
Unique_map('n', '<leader>s', ':%s:\\v::cg<Left><Left><Left><Left>', { remap = false , desc = 'Substitute pattern on whole file'})
Unique_map('v', '<leader>s', ':s:\\v::cg<Left><Left><Left><Left>', { remap = false , desc = 'Substitute pattern on visual selection'})

Unique_map('n', 'gp', '`[v`]', { remap = false, desc = 'Reselect pasted text'})
Unique_map({'n','v'}, 'p', 'mzp`[v`]=`z', { remap = false , desc = 'Format pasted text'})
Unique_map({'n','v'}, 'P', 'mzP`[v`]=`z', { remap = false , desc = 'Format pasted text'})

Unique_map('n', 'n', 'nzzzv', { remap = false , desc = 'Center the cursor after n'} )
Unique_map('n', 'N', 'Nzzzv', { remap = false , desc = 'Center the cursor after N'} )
Unique_map('n', 'J', 'mzJ`z', { remap = false , desc = 'Center the cursor after J'} )

-- " {{{1 Undo break points
Unique_map('i', ',', ',<C-g>u', { remap = false , desc ='Undo break point at ,'})
Unique_map('i', '.', '.<C-g>u', { remap = false , desc ='Undo break point at .'})
Unique_map('i', '!', '!<C-g>u', { remap = false , desc ='Undo break point at !'})
Unique_map('i', '?', '?<C-g>u', { remap = false , desc ='Undo break point at ?'})

Unique_map('n', '<leader>cl', ':set cursorline!<CR>', { remap = false, silent = true , desc = 'Toggle cursorline'} )
Unique_map('n', '<leader>cc', ':set cursorcolumn!<CR>', { remap = false , silent = true , desc = 'Toggle cursorcolumn'})

Unique_map('n', '/', '/\\v', { remap = false , desc = 'Case insensitive pattern search shortcut'})

--{{{1 Center cursor after a half page scroll without polluting the jump list
-- map('n', '<C-d>', '<C-d>zz', { remap = false })
-- map('n', '<C-u>', '<C-u>zz', { remap = false })

--{{{1 quickfix mappings
Unique_map('n', '<C-l>', ':cnext<CR>zv', { remap = false , desc = 'Go to next item in quickfix list'})
Unique_map('n', '<C-h>', ':cprev<CR>zv', { remap = false , desc = 'Go to prev item in quickfix list'})
Unique_map('n', '<C-q>', ':copen<CR>', { remap = false , desc = 'Open quickfix list'})

Unique_map('n', '<M-C-L>', ':lnext<CR>zv', { remap = false , desc = 'Go to next item in local quickfix list'})
Unique_map('n', '<M-C-H>', ':lprev<CR>zv', { remap = false , desc = 'Go to prev item in local quickfix list'})
Unique_map('n', '<M-C-Q>', ':lopen<CR>', { remap = false , desc = 'Open local quickfix list'})

-- " {{{1 Nicer tab switching
Unique_map('n', '<leader>1', '1gt', { remap = false, silent = true })
Unique_map('n', '<leader>2', '2gt', { remap = false, silent = true })
Unique_map('n', '<leader>3', '3gt', { remap = false, silent = true })
Unique_map('n', '<leader>4', '4gt', { remap = false, silent = true })
Unique_map('n', '<leader>5', '5gt', { remap = false, silent = true })

-- call :nohl
Unique_map('n', 'l', 'l<cmd>nohl<CR>', { remap = false })
Unique_map('n', 'h', 'h<cmd>nohl<CR>', { remap = false })
Unique_map('n', 'k', [[(v:count >= 5 ? "m'" . v:count : '') . 'gk<cmd>nohl<CR>']], { remap = false, expr = true , desc ='Add large j movements to the jump list and call :nohl'})
Unique_map('n', 'j', [[(v:count >= 5 ? "m'" . v:count : '') . 'gj<cmd>nohl<CR>']], { remap = false, expr = true , desc ='Add large k movements to the jump list and call :nohl'})

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

local lazy_opts = {
    defaults = {
        lazy = false,
    },
}

require("lazy").setup({
    'nvim-lua/plenary.nvim',       -- Never uninstall
    'mg979/vim-visual-multi',
    'lambdalisue/vim-suda',
    'christoomey/vim-system-copy', -- Requires xsel
    'ap/vim-css-color',
    'tpope/vim-surround',
    'joom/vim-commentary',
    'tpope/vim-repeat',
    'andymass/vim-matchup',
    'kyazdani42/nvim-web-devicons',
    'wellle/targets.vim',
    'szw/vim-maximizer',
    'mbbill/undotree',
    'unblevable/quick-scope',

    {
        'tpope/vim-fugitive',
        config = function ()
            Unique_map('n', '<F1>', ':tab Git<CR>', { remap = false, silent = true  })
        end,
    },

    {
        'junegunn/vim-easy-align',
        config = function ()
            Unique_map('v', 'ga', ':EasyAlign<CR>')
        end,
    },

    {

        'rcarriga/nvim-notify',
        config = function ()
            require('notify').setup{
                stages = "static",
                render = "wrapped-compact",
                timeout = 3000,
                top_down = false,
            }
            vim.notify = require('notify')
        end,
    },
    {
        'williamboman/mason.nvim',
        dependencies = { 'williamboman/mason-lspconfig.nvim', },
        config = function () require("mason").setup() end,
    },
    -- color schemes,
    {
        'sainnhe/sonokai',
        lazy = false,
        config = function () vim.cmd.colorscheme('sonokai') end,
    },

    {

        'nvim-telescope/telescope.nvim',
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
        },

        config = function ()
            require('telescope').setup {
                extensions = {
                    fzf = {}
                }
            }
            require('telescope').load_extension('fzf')

            Unique_map('n', 'g?', ':Telescope keymaps<CR>')
            Unique_map('n', '<leader>ff', ':Telescope find_files<CR>', { remap = false })
            Unique_map('n', '<leader>fg', ':Telescope live_grep<CR>' , { remap = false })
            Unique_map('n', '<leader>fb', ':Telescope buffers<CR>'   , { remap = false })
            Unique_map('n', '<leader>fh', ':Telescope help_tags<CR>' , { remap = false })
        end

    },
    {
        'windwp/nvim-autopairs',
        config = function ()
            require("nvim-autopairs").setup({
                check_ts = true,
                ts_config = {
                    lua = {'string'},-- it will not add a pair on that treesitter node
                }
            })
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        config = function ()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    'c',
                    'cpp',
                    'lua',
                    'make',
                    'vim',
                    'zig',
                    'vimdoc',
                },

                sync_install = false,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },

                indent = { enable = true },
            }
        end
    },
    {
        "nvim-treesitter/nvim-treesitter-textobjects",
        dependencies = { 'nvim-treesitter/nvim-treesitter', },
        config = function ()
            require'nvim-treesitter.configs'.setup {
                textobjects = {
                    select = {
                        enable = true,

                        -- Automatically jump forward to textobj, similar to targets.vim
                        lookahead = true,

                        keymaps = {
                            -- You can use the capture groups defined in textobjects.scm
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",

                            ["ia"] = "@assignment.rhs",
                            ["aa"] = "@assignment.lhs",
                            -- You can optionally set descriptions to the mappings (used in the desc parameter of
                            -- nvim_buf_set_keymap) which plugins like which-key display
                            ["ic"] = { query = "@class.inner", desc = "Select inner part of a class region" },
                            -- You can also use captures from other query groups like `locals.scm`
                            ["as"] = { query = "@scope", query_group = "locals", desc = "Select language scope" },
                            ["is"] = { query = "@scope.outer", query_group = "locals", desc = "Select language scope" },
                        },

                        selection_modes = {
                            ['@parameter.outer'] = 'v', -- charwise
                            ['@function.outer'] = 'V', -- linewise
                            ['@class.outer'] = '<c-v>', -- blockwise
                        },
                        include_surrounding_whitespace = false,
                    },

                    move = {
                        enable = true,
                        set_jumps = false,
                        goto_next_start = {
                            ['<M-f>'] = "@function.outer",
                        },
                        goto_previous_start = {
                            ['<M-C-f>'] = "@function.outer",
                        },
                    },

                },
            }
        end,
    },
    {
        'lukas-reineke/indent-blankline.nvim',
        config = function () require("ibl").setup {} end,
    },
    {
        'nvim-lualine/lualine.nvim',
        config = function () require("config_lualine") end,
    },
    {
        'lewis6991/gitsigns.nvim',
        config = function () require("config_gitsigns") end,
    },
    {
        'ziglang/zig.vim',
        init = function ()
            vim.g.zig_fmt_autosave = 1
        end,
    },
    -- Movement plugins,
    {
        'easymotion/vim-easymotion',
        init = function ()
            vim.g.EasyMotion_keys = 'aoeuhtnsid,lpgcr'

            Unique_map('n', '<leader>;', '<Plug>(easymotion-next)')
            Unique_map('n', '<leader>,', '<Plug>(easymotion-prev)')
            Unique_map('n', '<leader>wl', '<Plug>(easymotion-overwin-line)')
        end
    },

    -- Completion and snippets,
    {

        'L3MON4D3/LuaSnip',
        config = function () require("config_luasnip") end
    },
    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-path',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets',
            'onsails/lspkind-nvim',
        },

        event = "InsertEnter",
        config = function ()
            local cmp = require('cmp')
            local lspkind = require('lspkind')

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
                        require('luasnip').lsp_expand(args.body)
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

            local found_cmp_auto_pairs, cmp_auto_pairs = pcall(require,'nvim-autopairs.completion.cmp')
            if found_cmp_auto_pairs then
                cmp.event:on("confirm_done", cmp_auto_pairs.on_confirm_done( {map_char = { tex = ""}} ) )
            end
        end
    },

    -- Lsp,
    {

        'neovim/nvim-lspconfig',
        dependencies = {
            'ray-x/lsp_signature.nvim',
        },
        config = function () require('lsp') end
    },
}, lazy_opts)
