local map  = _G.Mappings.map
local cmd  = vim.cmd

local function m(name)
  local cwd = vim.api.nvim_exec('echo expand("%:p:h")', true)
  return string.match(cwd, name)
end

local function run(arg)
  return pcall(vim.api.nvim_exec, arg, true)
end

local function cmake(build_dir, build)
  local root = vim.lsp.buf.list_workspace_folders()[1]

  if not root then
    print("Run_code: Invalid dir")
    return
  end

  build_dir = root .. '/' .. build_dir

  local chdir = 'call chdir(  "' .. build_dir .. '"  )'
  if not run(chdir) then
    print("Run_code: Couldn't cd to dir")
    return
  end

  cmd 'wa'
  if build then
    cmd 'make'
  else
    cmd 'split | terminal "$SHELL" -c "make run"'
  end

  chdir = 'call chdir(  "' .. root .. '"  )'
  if not run(chdir) then
    print("Run_code: Couldn't cd to dir")
    return
  end
end

function Run_code()
  if m('opencv') then
    cmake('build', false)
  end
end

function Build_code()
  if m('opencv') then
    vim.opt.makeprg='cmake .. && make -i'
    cmake('build', true)
  end
end

map({'n'}, '<F8>', Run_code, {},
  'Run code')
map({'n'}, '<F3>', Build_code, {},
  'Build code')
