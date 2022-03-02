" {{{1 Telescope
nnoremap <leader>ff <cmd>Telescope find_files<CR>
nnoremap <leader>fg <cmd>Telescope live_grep<CR>
nnoremap <leader>fb <cmd>Telescope buffers<CR>
nnoremap <leader>fh <cmd>Telescope help_tags<CR>
" {{{1 easy motion

" {{{2 Global mapping
map <leader>; <Plug>(easymotion-next)
map <leader>, <Plug>(easymotion-prev)

" {{{2 Multi line
map <leader>f <Plug>(easymotion-bd-f)
map <leader>t <Plug>(easymotion-bd-t)
map <leader>b <Plug>(easymotion-bd-t2)
map s         <Plug>(easymotion-s2)

" {{{2 Multi line Overwindows
nmap <leader>wl <Plug>(easymotion-overwin-line)

" {{{1 Limelight
nnoremap <silent> <leader>l :Limelight!!<CR>
" {{{1 surround.vim
nmap S <Plug>Ysurround
" {{{1 fugitive
nnoremap <F1> :tab Git<CR>
" {{{1 vim-maximizer
noremap <C-w><C-m> :MaximizerToggle<CR>
" {{{1 vim-easy-align
vmap ga <Plug>(EasyAlign)
" {{{1 Nvim-tree
nnoremap <leader>fo :NvimTreeToggle<CR>
" {{{1 SymbolsOutline
nnoremap <leader>ol :SymbolsOutline<CR>
" {{{1 Gitsings
nnoremap <leader>hp :Gitsigns preview_hunk<CR>
