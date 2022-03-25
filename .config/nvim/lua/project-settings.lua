local map = _G.Mappings.map
local cwd = vim.api.nvim_exec('echo expand("%:p:h")',true)

local function m(name)
  return string.match(cwd, name)
end

vim.cmd[[
  function! Make_build(build_dir)
  let l:root = luaeval("vim.lsp.buf.list_workspace_folders()[1]")

  if l:root == "null"
    echo "Make_build: Invalid dir"
    return
  endif

  let l:build = l:root . "/" . a:build_dir
  let l:prev_dir = execute('pwd')

  call chdir(l:build)
  make
  call chdir(l:root)
  endfunction
]]

if m('opencv') then
  vim.opt.makeprg='cmake .. && cmake --build .'
  map('n', '<F8>', ':wa<CR>:!./run.sh<CR>', {},
    'Run code', 0)
  map('n', '<F3>', ':call Make_build("build")<CR>', {},
    'Build code', 0)
end
