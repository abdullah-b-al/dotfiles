local api = vim.api
-- Helper function
function noremap(mode, lhs, rhs)
    local options = {noremap = true}
    api.nvim_set_keymap(mode, lhs, rhs, options)
end
function map(mode, lhs, rhs)
    api.nvim_set_keymap(mode, lhs, rhs, {})
end
