local map = _G.Mappings.map

function _G.harpooning(command, number)
  vim.cmd 'PackerLoad harpoon'

  if command == "open" then
    require("harpoon.ui").toggle_quick_menu()
  elseif command == 'add_file' then
    require("harpoon.mark").add_file()
  elseif command == 'nav_file' then
    require("harpoon.ui").nav_file(number)
  end
end

map('n', '<leader>gg', ':lua harpooning("open")<CR>', {} , 'Harpoon: Open window')
map('n', '<leader>ga', ':lua harpooning("add_file")<CR>', {}, 'Harpoon: Add file')
map('n', '<leader>gn', ':lua harpooning("nav_file", 1)<CR>', {}, 'Harpoon: Navigate to mark 1')
map('n', '<leader>ge', ':lua harpooning("nav_file", 2)<CR>', {}, 'Harpoon: Navigate to mark 2')
map('n', '<leader>gi', ':lua harpooning("nav_file", 3)<CR>', {}, 'Harpoon: Navigate to mark 3')
