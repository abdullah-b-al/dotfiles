local map = _G.Mappings.map
local cwd = vim.api.nvim_exec('echo expand("%:p:h")',true)

local function m(name)
  return string.match(cwd, name)
end

vim.cmd[[
  function! CMake_build(build_dir)
  let l:root = luaeval("vim.lsp.buf.list_workspace_folders()[1]")

  if l:root == "null"
    echo "CMake_build: Invalid dir"
    return
  endif

  let l:build = l:root . "/" . a:build_dir

  call chdir(l:build)
  make
  call chdir(l:root)
  endfunction

  function! Make_run_build(build_dir)
  let l:root = luaeval("vim.lsp.buf.list_workspace_folders()[1]")

  if l:root == "null"
    echo "Make_run_build: Invalid dir"
    return
  endif

  let l:build = l:root . "/" . a:build_dir

  call chdir(l:build)
  split | terminal "$SHELL" -c "make run"
  call chdir(l:root)
  endfunction
]]

if m('opencv') then
  vim.opt.makeprg='cmake .. && make -i'
  map('n', '<F8>', ':call Make_run_build("build")<CR>', {},
    'Run code', 0)
  map('n', '<F3>', ':call CMake_build("build")<CR>', {},
    'Build code', 0)
end
