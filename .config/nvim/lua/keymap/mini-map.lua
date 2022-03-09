local map = _G.Mappings.map

function _G.toggle_minimap()
  vim.cmd[[
  MinimapToggle
  MinimapRefresh
  ]]
end

map('n', '<leader>mm', ':lua _G.toggle_minimap()<CR>', { noremap = true, silent = true },
  'Toggle minimap')
