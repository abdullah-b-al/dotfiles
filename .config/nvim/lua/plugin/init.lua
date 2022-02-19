local dir = 'plugin'
return {
    require(dir .. '/lua-line'),
    require(dir .. '/nvim-cmp'),
    require(dir .. '/symbols-outline'),
    require(dir .. '/tree-sitter'),
}
