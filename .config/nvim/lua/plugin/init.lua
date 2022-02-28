local dir = 'plugin'
return {
  require(dir .. '/lua-line'),
  require(dir .. '/nvim-cmp'),
  require(dir .. '/tree-sitter'),
  require(dir .. '/indent-line'),
  require(dir .. '/nvim-tree'),
  require(dir .. '/neoscroll'),
  require(dir .. '/autopairs'),
  require(dir .. '/gitsigns'),
}
