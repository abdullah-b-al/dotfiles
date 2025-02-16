local home = vim.env.HOME

local M = {}

local get_project_name = function(buf)
    buf = buf or 0
    local path = vim.fs.root(buf, ".git")
    local name = vim.fs.basename(path)
    return name
end

local get_language = function()
    local lang = vim.bo.filetype
    return lang
end

local find_tab_of = function(file_name)
    for _, tab in ipairs(vim.api.nvim_list_tabpages()) do
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tab)) do
            local buf = vim.api.nvim_win_get_buf(win)
            if vim.api.nvim_buf_get_name(buf) == file_name then
                return {tab=tab, win=win, buf=buf}
            end
        end
    end

    return nil
end

M.open_notes = function()
    local name = get_project_name()
    if name == 'personal' then
        vim.api.nvim_command("tabc")
    elseif name ~= nil then
        local base_path = home .. "/personal/notes/"
        local project = base_path .. name .. ".md"
        local lang = base_path .. get_language() .. ".md"

        local tab = find_tab_of(project)

        if tab then
            vim.api.nvim_set_current_tabpage(tab.tab)
        else
            vim.api.nvim_command("tabe " .. lang)
            vim.api.nvim_command("leftabove vs " .. project)
        end
    end

end

M.open_vim_notes = function()
    local file = home .. "/personal/vim_notes.md"
    vim.api.nvim_command("edit " .. file)
end

-- or locallist
M.focused_list = "quickfix"
M.traverse_list = function(next)
    local result
    if M.focused_list == "quickfix" then
        if next then
            _, result = pcall(vim.api.nvim_command, "cnext")
        else
            _, result = pcall(vim.api.nvim_command, "cprev")
        end
    elseif M.focused_list == "locallist" then
        if next then
            _, result = pcall(vim.api.nvim_command, "lnext")
        else
            _, result = pcall(vim.api.nvim_command, "lprev")
        end
    end

    if result ~= nil then
        vim.notify(result)
    end
    pcall(vim.api.nvim_command, "norm zz")

    return true
end

M.open_list = function()
    if M.focused_list == "quickfix" then
        pcall(vim.api.nvim_command, "copen")
    elseif M.focused_list == "locallist" then
        pcall(vim.api.nvim_command, "lopen")
    end
end

M.toggle_list = function()
    if M.focused_list == "quickfix" then
        M.focused_list = "locallist"
    else
        M.focused_list = "quickfix"
    end
    vim.notify("Currently focused: " .. M.focused_list)
end

return M
