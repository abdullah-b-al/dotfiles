-- vim: foldmethod=expr foldnestmax=1 nofoldenable
-- Variables
local cmd        = vim.cmd
local g          = vim.g
local opt        = vim.opt
local home       = vim.env.HOME
local nvim_input = vim.api.nvim_input

if vim.loader then
    vim.loader.enable()
end

function Unique_map(modes, lhs, rhs, opts)
    opts = opts or {}
    if opts.unique == nil then
        local keys_to_ignore = { '<C-l>' }
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
opt.tabstop        = 4 -- Tab width in spaces
opt.softtabstop    = 4 -- Tab width in spaces when performing editing operations
opt.shiftwidth     = 4 -- Number of spaces to use for each step of (auto)indent
opt.updatetime     = 1000
opt.timeoutlen     = 300
opt.colorcolumn    = { 80 }

opt.modelineexpr   = true
opt.expandtab      = true
opt.smartindent    = true
opt.number         = true -- Current line number
opt.smartcase      = true
opt.incsearch      = true -- Highlights search results as you type
opt.relativenumber = true
opt.spell          = true
opt.cursorline     = true
opt.showmode       = true -- Disabling showmode will hide complete mode
opt.termguicolors  = true
opt.splitbelow     = true
opt.splitright     = true
opt.ignorecase     = true
opt.smartcase      = true
opt.foldenable     = false
opt.foldlevel      = 1
opt.wrap           = false

opt.dictionary     = opt.dictionary + '/usr/share/dict/words'
opt.spellfile      = home .. '/.local/share/nvim/spell/en.utf-8.add'
opt.viewoptions    = 'cursor' -- save/restore just these with {mk,load}view`

opt.foldmethod     = 'manual'
opt.foldmethod     = 'expr'
opt.foldexpr       = "v:lua.vim.treesitter.foldexpr()"

-- Globals
g.mapleader        = ' '
g.maplocalleader   = ','

if vim.g.neovide then
    vim.o.guifont = "Ubuntu Mono:h14"
    vim.g.neovide_cursor_animation_length = 0
    vim.g.neovide_scroll_animation_length = 0.25
    vim.g.neovide_cursor_trail_size = 0.05
    vim.g.neovide_refresh_rate_idle = 0
end


-- Auto commands
cmd('source ' .. vim.env.HOME .. '/.config/nvim/after/commands.vim')

vim.api.nvim_create_user_command("Cc", "cd %:h", {})

-- Section: Auto commands
-- Disable colorcolumn for certain file types
vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "*.markdown", "*.txt", "*.netrw" },
    callback = function() vim.cmd('set colorcolumn=0') end
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
    callback = function()
        require("per-project-settings").apply(0)
    end,
})

vim.api.nvim_create_autocmd({ "vimenter", "ColorScheme" }, {
    pattern = { "*" },
    callback = function()
        vim.cmd('highlight! MatchParen guifg=#FF0000 guibg=#202020 gui=NONE ctermfg=196 ctermbg=233 cterm=reverse')
        vim.cmd('hi! VM_Mono guibg=#CC1111 guifg=Black gui=NONE')
        vim.cmd('hi! MultiCursor guibg=#61AFEF guifg=Black gui=NONE')
        vim.cmd('hi! MultiCursorMain guibg=#21AFEF guifg=Black gui=NONE')
    end
})


-- Section: Mappings

Unique_map('n', '<F5>', function()
    vim.cmd("source ~/.config/nvim/init.lua")
    package.loaded["per-project-settings"] = nil -- For force reloading
    for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
        require("per-project-settings").apply(bufnr)
    end
end, { remap = false, desc = 'Reload init.lua' })

Unique_map('n', '<M-x>', function()
        nvim_input("V")
        nvim_input(tostring(vim.v.count) .. "j")
    end,
    { noremap = true, desc = 'Visual line and go down' })
Unique_map('n', '<M-X>', function()
        nvim_input("V")
        nvim_input(tostring(vim.v.count) .. "k")
    end,
    { noremap = true, desc = 'Visual line and go up' })
Unique_map({ 'v' }, '<M-x>', 'gj', { noremap = true })
Unique_map({ 'v' }, '<M-X>', 'gk', { noremap = true })

Unique_map({ 'v' }, '<leader>a', '<CMD>norm gc<CR>', { noremap = true })
Unique_map({ 'n' }, '<leader>a', '<CMD>norm gcc<CR>', { noremap = true })
Unique_map({ 'n', 'v' }, '<C-y>', '2<C-y>')
Unique_map({ 'n', 'v' }, '<C-e>', '2<C-e>')
Unique_map('n', '<F12>', ':set spell!<CR>', { silent = true, desc = 'Toggle spell on and off' })
Unique_map('n', '<localleader>,', ':norm ,<CR>',
    { remap = false, silent = true, desc = 'Map ,, to find previous char without triggering other localleader commands' })
Unique_map('t', '<Esc><Esc>', '<C-\\><C-n>', { remap = false, desc = 'Terminal mode setting for NeoVim' })
Unique_map('n', '<localleader>d', '"_d', { remap = false, desc = 'Quick access to blackhole delete' })


--{{{1 Substitution
Unique_map('n', '<leader>s', ':%s:\\v::cg<Left><Left><Left><Left>',
    { remap = false, desc = 'Substitute pattern on whole file' })
Unique_map('v', '<leader>s', ':s:\\v::cg<Left><Left><Left><Left>',
    { remap = false, desc = 'Substitute pattern on visual selection' })
Unique_map('n', '<leader>g', ':%g:\\v::cg<Left><Left><Left><Left>',
    { remap = false, desc = 'Substitute pattern on whole file' })
Unique_map('v', '<leader>g', ':g:\\v::cg<Left><Left><Left><Left>',
    { remap = false, desc = 'Substitute pattern on visual selection' })

Unique_map('n', '<leader>v', '`[v`]', { remap = false, desc = 'Reselect pasted or yanked text' })
Unique_map({ 'n', 'v' }, 'p', 'p`[v`]=', { remap = false, desc = 'Paste and format' })
Unique_map({ 'n', 'v' }, 'P', 'P`[v`]=', { remap = false, desc = 'Paste and format' })
Unique_map({ 'n', 'v' }, '<leader>p', '"+p`[v`]', { remap = false, desc = 'Paste and Select clipboard' })
Unique_map({ 'n', 'v' }, '<leader>P', '"+P`[v`]', { remap = false, desc = 'Paste and Select clipboard' })

Unique_map('n', 'n', 'nzzzv', { remap = false, desc = 'Center the cursor after n' })
Unique_map('n', 'N', 'Nzzzv', { remap = false, desc = 'Center the cursor after N' })
Unique_map('n', 'J', 'mzJ`z', { remap = false, desc = 'Center the cursor after J' })

-- " {{{1 Undo break points
Unique_map('i', ',', ',<C-g>u', { remap = false, desc = 'Undo break point at ,' })
Unique_map('i', '.', '.<C-g>u', { remap = false, desc = 'Undo break point at .' })
Unique_map('i', '!', '!<C-g>u', { remap = false, desc = 'Undo break point at !' })
Unique_map('i', '?', '?<C-g>u', { remap = false, desc = 'Undo break point at ?' })

Unique_map('n', '<leader>cl', ':set cursorline!<CR>', { remap = false, silent = true, desc = 'Toggle cursorline' })
Unique_map('n', '<leader>cc', ':set cursorcolumn!<CR>', { remap = false, silent = true, desc = 'Toggle cursorcolumn' })

Unique_map('n', '/', '/\\v', { remap = false, desc = 'Case insensitive pattern search shortcut' })

--{{{1 Center cursor after a half page scroll without polluting the jump list
-- map('n', '<C-d>', '<C-d>zz', { remap = false })
-- map('n', '<C-u>', '<C-u>zz', { remap = false })

--{{{1 quickfix mappings
Unique_map('n', '<C-l>', function() require("extra").traverse_list(true) end,
    { remap = false, desc = 'Go to next item in quickfix list' })
Unique_map('n', '<C-h>', function() require("extra").traverse_list(false) end,
    { remap = false, desc = 'Go to prev item in quickfix list' })
Unique_map('n', '<C-q>', function() require("extra").open_list() end, { remap = false, desc = 'Open quickfix list' })
Unique_map('n', '<A-q>', function() require("extra").toggle_list() end, { remap = false, desc = 'Open quickfix list' })

-- " {{{1 Nicer tab switching
Unique_map('n', '<leader>1', '1gt', { remap = false, silent = true })
Unique_map('n', '<leader>2', '2gt', { remap = false, silent = true })
Unique_map('n', '<leader>3', '3gt', { remap = false, silent = true })
Unique_map('n', '<leader>4', '4gt', { remap = false, silent = true })
Unique_map('n', '<leader>5', '5gt', { remap = false, silent = true })

-- call :nohl
Unique_map('n', 'l', 'l<cmd>nohl<CR>', { remap = false })
Unique_map('n', 'h', 'h<cmd>nohl<CR>', { remap = false })
Unique_map('n', 'k', [[(v:count >= 5 ? "m'" . v:count : '') . 'gk<cmd>nohl<CR>']],
    { remap = false, expr = true, desc = 'Add large j movements to the jump list and call :nohl' })
Unique_map('n', 'j', [[(v:count >= 5 ? "m'" . v:count : '') . 'gj<cmd>nohl<CR>']],
    { remap = false, expr = true, desc = 'Add large k movements to the jump list and call :nohl' })

-- Unique_map('n', '<leader><localleader>t', function() require("extra").open_todo() end, { remap = false, desc ='Open TODO'})
Unique_map('n', '<leader><localleader>d', function() require("extra").open_vim_notes() end,
    { remap = false, desc = 'Open vim_notes' })
Unique_map('n', '<leader><localleader>n', function() require("extra").open_notes() end,
    { remap = false, desc = 'Open project and language notes' })

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
    rocks = {
        enabled = false,
    },
    defaults = {
        lazy = false,
    },
}

require("lazy").setup({
    'nvim-lua/plenary.nvim', -- Never uninstall

    {
        'jake-stewart/multicursor.nvim',
        config = function()
            local mc = require("multicursor-nvim")
            mc.setup()

            -- Add or skip cursor above/below the main cursor.
            Unique_map({ "x" }, "M", mc.splitCursors)
            Unique_map({ "x" }, "s", mc.matchCursors)
            Unique_map({ "n", "x" }, "<M-k>", function() mc.lineAddCursor(-1) end)
            Unique_map({ "n", "x" }, "<M-j>", function() mc.lineAddCursor(1) end)
            Unique_map({ "n", "x" }, "<leader><up>", function() mc.lineSkipCursor(-1) end)
            Unique_map({ "n", "x" }, "<leader><down>", function() mc.lineSkipCursor(1) end)
            Unique_map("n", "<leader>cr", mc.restoreCursors, { desc = "MultiCursor: Restore cursors" })

            -- Add or skip adding a new cursor by matching word/selection
            Unique_map({ "n", "x" }, "<C-n>", function() mc.matchAddCursor(1) end,
                { desc = "MultiCursor: Match and add next" })
            Unique_map({ "n", "x" }, "<M-n>", function() mc.matchAddCursor(-1) end,
                { desc = "MultiCursor: Match and Add previous" })
            Unique_map({ "n", "x" }, "<leader>n", function() mc.matchSkipCursor(1) end,
                { desc = "MultiCursor: Match and skip next" })
            Unique_map({ "n", "x" }, "<leader>N", function() mc.matchSkipCursor(-1) end,
                { desc = "MultiCursor: Match and skip previous" })
            Unique_map("v", "<leader>t", function() mc.transposeCursors(1) end)

            -- Disable and enable cursors.
            -- Unique_map({"n", "x"}, "<c-q>", mc.toggleCursor)

            -- Mappings defined in a keymap layer only apply when there are
            -- multiple cursors. This lets you have overlapping mappings.
            mc.addKeymapLayer(function(layerSet)
                -- Select a different cursor as the main one.
                layerSet({ "n", "x" }, "<left>", mc.prevCursor)
                layerSet({ "n", "x" }, "<right>", mc.nextCursor)

                -- Delete the main cursor.
                layerSet({ "n", "x" }, "<leader>x", mc.deleteCursor)

                -- Enable and clear cursors using escape.
                layerSet("n", "<esc>", function()
                    if not mc.cursorsEnabled() then
                        mc.enableCursors()
                    else
                        mc.clearCursors()
                    end
                end)
            end)

            -- Customize how cursors look.
            local hl = vim.api.nvim_set_hl
            hl(0, "MultiCursorCursor", { link = "Cursor" })
            hl(0, "MultiCursorVisual", { link = "Visual" })
            hl(0, "MultiCursorSign", { link = "SignColumn" })
            hl(0, "MultiCursorMatchPreview", { link = "Search" })
            hl(0, "MultiCursorDisabledCursor", { link = "Visual" })
            hl(0, "MultiCursorDisabledVisual", { link = "Visual" })
            hl(0, "MultiCursorDisabledSign", { link = "SignColumn" })
        end
    },
    'lambdalisue/vim-suda',
    'christoomey/vim-system-copy', -- Requires xsel
    'ap/vim-css-color',
    'tpope/vim-surround',
    'tpope/vim-repeat',
    'andymass/vim-matchup',
    'kyazdani42/nvim-web-devicons',
    'wellle/targets.vim',
    'mbbill/undotree',

    {
        'sainnhe/sonokai',
        lazy = false,
        config = function() vim.cmd.colorscheme('sonokai') end,
    },

    {

        'nvim-telescope/telescope.nvim',
        -- dependencies = {
        --     { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' }
        -- },

        config = function()
            require("config_telescope")
        end

    },
    {
        'windwp/nvim-autopairs',
        config = function()
            require("nvim-autopairs").setup({
                check_ts = false,
            })
        end
    },
    {
        'nvim-treesitter/nvim-treesitter',
        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = {
                    'vimdoc',
                },

                sync_install = false,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },

                indent = { enable = true },
                incremental_selection = {
                    enable = false,
                    keymaps = {
                        init_selection = '<CR>',
                        scope_incremental = '<CR>',
                        node_incremental = '<TAB>',
                        node_decremental = '<S-TAB>',
                    },
                },
            }
        end
    },
    {
        'nvim-lualine/lualine.nvim',
        config = function() require("config_lualine") end,
    },
    {
        'lewis6991/gitsigns.nvim',
        config = function() require("config_gitsigns") end,
    },
    {
        'justinmk/vim-sneak',
    },

    {
        'hrsh7th/nvim-cmp',
        dependencies = {
            'hrsh7th/cmp-path',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip',
            'rafamadriz/friendly-snippets',
            'onsails/lspkind-nvim',
            'hrsh7th/cmp-calc',
            'hrsh7th/cmp-buffer',
        },

        event = "InsertEnter",
        config = function()
            local cmp = require('cmp')

            vim.opt.completeopt = { 'menuone', 'preview' }

            cmp.setup({
                experimental = {
                    ghost_text = true,
                },
                completion = {
                    keyword_length = 3,
                },
                mapping = {
                    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
                    ['<C-d>'] = cmp.mapping.scroll_docs(4),
                    ['<C-c>'] = cmp.mapping.abort(), -- Close menu and reject selection
                    ['<C-e>'] = cmp.mapping.complete(),
                    ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                    ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                },
                sources = {
                    { name = 'calc' },
                    { name = 'luasnip' },
                    { name = 'path' },
                    {
                        name = 'buffer',
                        option = { get_bufnrs = function() return vim.api.nvim_list_bufs() end }
                    },

                },
            })

            vim.opt.pumheight = 10

            local found_cmp_auto_pairs, cmp_auto_pairs = pcall(require, 'nvim-autopairs.completion.cmp')
            if found_cmp_auto_pairs then
                cmp.event:on("confirm_done", cmp_auto_pairs.on_confirm_done({ map_char = { tex = "" } }))
            end
        end
    },

}, lazy_opts)
