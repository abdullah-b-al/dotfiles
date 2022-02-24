require('neoscroll').setup({
    mappings = {'<C-u>', '<C-d>', '<C-b>', '<C-f>'},
    hide_cursor = true,          -- Hide cursor while scrolling
    stop_eof = true,             -- Stop at <EOF> when scrolling downwards
    use_local_scrolloff = false, -- Use the local scope of scrolloff instead of the global scope
    respect_scrolloff = false,   -- Stop scrolling when the cursor reaches the scrolloff margin of the file
    cursor_scrolls_alone = true, -- The cursor will keep on scrolling even if the window cannot scroll further
    easing_function = nil,       -- Default easing function
    performance_mode = false,    -- Disable "Performance Mode" on all buffers.
    post_hook = function()
        vim.cmd('norm zz')       -- Center cursor
    end,

})

require('neoscroll.config').set_mappings({
    ['<C-u>'] = {'scroll', {'-vim.wo.scroll', 'true', '100'}},
    ['<C-d>'] = {'scroll', { 'vim.wo.scroll', 'true', '100'}},
    ['<C-b>'] = {'scroll', {'-vim.api.nvim_win_get_height(0)', 'true', '150'}},
    ['<C-f>'] = {'scroll', { 'vim.api.nvim_win_get_height(0)', 'true', '150'}},
})
