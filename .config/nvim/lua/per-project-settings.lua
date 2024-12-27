local home = vim.env.HOME

-- All settings should be in this function
local apply = function (bufnr)
    if bufnr == nil then
        print("per-project-settings: Buffer number not provided")
        return
    end

    local path = vim.api.nvim_buf_get_name(bufnr)
    local dir = vim.fs.dirname(path)
end -- apply function end

return { apply = apply }
