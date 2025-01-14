local home = vim.env.HOME

local M = {}

M.open_todo = function()
    local path = vim.fs.root(0, ".git")
    local name = vim.fs.basename(path)
    if name == nil or name == "personal" then return end

    local base_path = home .. "/personal/todo/"
    local file = base_path .. name
    vim.api.nvim_command("edit " .. file)
end

return M
