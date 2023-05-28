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
    cmd 'bot split | terminal "$SHELL" -c "make run"'
  end

  chdir = 'call chdir(  "' .. root .. '"  )'
  if not run(chdir) then
    print("Run_code: Couldn't cd to dir")
    return
  end
end

if m('suckless/st') or m('suckless/dwm') then
  vim.opt.expandtab = false
  vim.opt.makeprg = 'make'
  map({'n'}, '<F8>', '<cmd>wa<CR><cmd>make<CR>', {},
    'Build code')

elseif m('opencv') then
  vim.opt.expandtab = true
  vim.opt.makeprg='cmake .. && make -i'
  map({'n'}, '<F8>', function () cmake('build', true) end, {},
    'Build code')
  map({'n'}, '<F3>', function () cmake('build', false) end, {},
    'Run code')
end

local file_name = vim.api.nvim_exec('echo expand("%")', true)
if string.match(file_name, '.zig') then
  map({'n'}, '<F8>', function ()
    cmd 'wa'
    cmd 'make'
  end, {},
    'Build code')

  map({'n'}, '<F3>', function ()
    cmd 'wa'

    cmd 'bot split | terminal "$SHELL" -c "zig build run"'

  end, {},
    'Run code')

  map({'n'}, '<F9>', function ()
    cmd 'wa'
    cmd 'bot split | terminal "$SHELL" -c "zig build test"'
  end, {},
    'Run tests')

  map({'n'}, '<F4>', function ()
    cmd 'wa'
    cmd 'bot split | terminal "$SHELL" -c "zig test % --main-pkg-path ."'
  end, {},
    'Test file')
end
