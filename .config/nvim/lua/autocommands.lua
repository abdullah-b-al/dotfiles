vim.api.nvim_create_autocmd( {"DirChanged"}, {
  callback = function ()
    vim.cmd'luafile ~/.config/nvim/lua/project-settings.lua'
  end
})
