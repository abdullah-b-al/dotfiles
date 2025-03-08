require('telescope').setup {
    extensions = {
        fzf = {}
    }
}

local opts = {
    no_ignore = false,
    layout_config = {
        height = 0.5,
        width = 0.99,
    },
}

local opts_no_ignore = vim.tbl_deep_extend("keep", {no_ignore = true}, opts)

local builtin = require('telescope.builtin')
local themes = require('telescope.themes')
local theme = themes.get_ivy

require('telescope').load_extension('fzf')
require('telescope.actions')

Unique_map('n', 'g?', function() builtin.keymaps(theme(opts)) end, { remap = false, desc = "Telescope: Mapping Picker" })
Unique_map('n', '<leader>t', function() builtin.lsp_document_symbols(theme(opts)) end, { remap = false, desc = "Telescope: LSP Document Symbols" })
Unique_map('n', '<leader>r', function() builtin.lsp_dynamic_workspace_symbols(theme(opts)) end, { remap = false , desc = "Telescope: LSP Workspace Symbols" })
Unique_map('n', '<leader>p', function() builtin.current_buffer_fuzzy_find(theme(opts)) end, { remap = false , desc = "Telescope: Current Buffer Fuzzy Find" })
Unique_map('n', '<leader>o',  function() builtin.find_files(theme(opts)) end, { remap = false, desc = 'Telescope: Find Files' })
Unique_map('n', '<localleader>o',  function() builtin.find_files(theme(opts_no_ignore)) end, { remap = false, desc = 'Telescope: Find Files(no ignore)' })
Unique_map('n', '<leader>i',  function() builtin.live_grep(theme(opts)) end , { remap = false , desc = "Telescope: Live Grep" })
Unique_map('n', '<leader>e',  function() builtin.buffers(theme(opts)) end   , { remap = false , desc = "Telescope: Buffers" })
Unique_map('n', '<leader>q',  function() builtin.help_tags(theme(opts)) end , { remap = false , desc = "Telescope: Help Tags" })

-- Grep searching relevant dirs for a file type 
Unique_map('n', '<localleader>i',  function()
    local t = {
        { pattern = "odin$", dirs = {vim.env["ODIN_ROOT"]} },
        { pattern = "zig$", dirs = {vim.env.HOME .. '/zig/master'},
        },
    }

    local search_dirs = {}
    local name = vim.api.nvim_buf_get_name(0)
    for _, v in ipairs(t) do
        if string.match(name, v.pattern) then
            search_dirs = v.dirs
        end
    end

    builtin.live_grep(vim.tbl_deep_extend('keep',
        theme(opts), {search_dirs = search_dirs }))
end , { remap = false, desc = "Telescope: Live Grep In Language Directories" })
