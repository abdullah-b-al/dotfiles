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

Unique_map('n', 'g?', function() builtin.keymaps(theme(opts)) end, { remap = false })
Unique_map('n', '<M-f>', function() builtin.lsp_document_symbols(theme(opts)) end, { remap = false })
Unique_map('n', '<M-F>', function() builtin.lsp_dynamic_workspace_symbols(theme(opts)) end, { remap = false })
Unique_map('n', '<M-p>', function() builtin.current_buffer_fuzzy_find(theme(opts)) end, { remap = false })
Unique_map('n', '<leader>ff',  function() builtin.find_files(theme(opts)) end, { remap = false, desc = 'find files' })
Unique_map('n', '<leader>if',  function() builtin.find_files(theme(opts_no_ignore)) end, { remap = false, desc = 'find files' })
Unique_map('n', '<leader>fg',  function() builtin.live_grep(theme(opts)) end , { remap = false })
Unique_map('n', '<leader>fb',  function() builtin.buffers(theme(opts)) end   , { remap = false })
Unique_map('n', '<leader>fh',  function() builtin.help_tags(theme(opts)) end , { remap = false })

-- Grep searching relevant dirs for a file type 
Unique_map('n', '<leader>fp',  function()
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
end , { remap = false })
