vim.api.nvim_exec(
[[
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
]]
,false
)
vim.opt.completeopt ={"menuone", "noinsert"}
