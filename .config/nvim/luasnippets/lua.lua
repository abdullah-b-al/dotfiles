local ls = require('luasnip')
ls.snippets = {
  lua = {
    ls.parser.parse_snippet("pe", [[print("", .{});]]),
  }
}
