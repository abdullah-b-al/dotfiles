local ls = require('luasnip')

local types = require('luasnip.util.types')

-- Load snippets from friendlysnippets library
-- require("luasnip.loaders.from_vscode").lazy_load()
-- require("luasnip.loaders.from_lua").lazy_load( { path = vim.env.HOME .. '/.config/nvim/luasnippets/lua.lua' } )
ls.config.set_config {
    history = true,

    update_events = 'TextChanged, TextChangedI',

    enable_autosnippets = true,

    ext_opts = {
        [types.choiceNode] = {
            active = {
                virt_text = { { '<-', 'Error' } },
            },
        },
    },
}

Unique_map("n", '<leader><leader>s', "<CMD>source ~/.config/nvim/lua/config_luasnip.lua | lua vim.notify('Sourced luasnip')<CR>", { desc =  'LuaSnip: reload snippets'})
Unique_map({'i','s'}, '<C-l>', function() require('luasnip').jump(1) end, { desc =  'LuaSnip: Jump forward'})
Unique_map({'i','s'}, '<C-h>', function() require('luasnip').jump(-1) end, {  desc = 'LuaSnip: Jump backword'})

local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep
local s = ls.snippet
local i = ls.insert_node

local langs = {
    "lua", "zig",
}
for _, l in ipairs(langs) do
    require("luasnip.session.snippet_collection").clear_snippets(l)
end

ls.add_snippets("zig", {
    s("ifc", fmta("if (<logic>) |<capture>| {\n}", {logic = i(1), capture = i(2)})),
    s("lst", fmta("var <name> = std.ArrayList(<type>).init(allocator);", {name = i(1), type = i(2)})),
    s("eql", fmta("std.mem.eql(<type>, <a>, <b>)", {type = i(1), a = i(2), b = i(3)})),
    s("itr", fmta([[
var <iter> = <object>.iterator();
while (<riter>.next()) |<capture>| {
}
]], {iter = i(1), object = i(2), riter = rep(1), capture = i(3)})),

})
