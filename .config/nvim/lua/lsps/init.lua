local dir = 'lsps'
return {
    require(dir .. '/ccls'),
    require(dir .. '/clangd'),
    require(dir .. '/clojure_server'),
    require(dir .. '/lua_server'),
    require(dir .. '/zig_server'),
}
