local found_lspconfig = pcall(require, 'lspconfig')
local found_signature = pcall(require, 'lsp_signature')
local found_cmp       = pcall(require, 'cmp_nvim_lsp')

if not found_lspconfig then
  print("Couldn't find lspconfig in lsps/init.lua")
  return
end
if not found_signature then
  print("Couldn't find lsp-signature in lsps/init.lua")
  return
end
if not found_cmp then
  print("Couldn't find cmp in lsps/init.lua")
  return
end

local dir = 'lsps'
return {
  -- require(dir .. '/ccls'),
  require(dir .. '/omnisharp'),
  require(dir .. '/clangd'),
  require(dir .. '/clojure_server'),
  -- require(dir .. '/lua_server'),
  require(dir .. '/zig_server'),
  require(dir .. '/go_server'),
  require(dir .. '/python_server'),
  require(dir .. '/cmake_server'),
}
