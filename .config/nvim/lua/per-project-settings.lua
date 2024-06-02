local home = vim.env.HOME
local map = vim.keymap.set

-- All settings should be in this function
local apply = function (bufnr)
    if bufnr == nil then
        print("per-project-settings: Buffer number not provided")
        return
    end

    local path = vim.api.nvim_buf_get_name(bufnr)
    local dir = vim.fs.dirname(path)

    if path:match("resume/resume.tex") then
        local rhs = string.format([[:wa | !pdflatex -output-directory="%s" %% > /dev/null<CR>]], dir)
        map('n', '<F8>', rhs, {buffer = bufnr})
    end
end -- apply function end

return { apply = apply }
