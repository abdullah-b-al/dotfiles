" {{{1 Toggle spell on and off
nmap <silent> <F12> :set spell!<CR>

" {{{1 Map ,, to find previous char without triggering other localleader commands
nnoremap <localleader>, :norm ,<CR>

" {{{1 Terminal mode setting for NeoVim
tnoremap <C-n><Esc> <C-\><C-n>

" {{{1 Diff since last save
nmap <leader>d :w !diff % -<CR>

" {{{1 Substitution
nnoremap <leader>s :%s:\v::cg<Left><Left><Left><Left>
vnoremap <leader>s :s:\v::cg<Left><Left><Left><Left>

" {{{1 Reselect pasted text
nnoremap gp `[v`]

" {{{1 Yank to the end of the line
nnoremap Y y$

" {{{1 Keep cursor centered on the screen
"  zz centers the curser
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z

" {{{1 Undo break points
inoremap , ,<C-g>u
inoremap . .<C-g>u
inoremap ! !<C-g>u
inoremap ? ?<C-g>u

" {{{1 Moving text
vnoremap <silent> J :m '>+1<CR>gv=gv
vnoremap <silent> K :m '<-2<CR>gv=gv

" {{{1 Toggle cursorline and cursorcolumn
nnoremap <silent> <leader>cl :set cursorline!<CR>
nnoremap <silent> <leader>cc :set cursorcolumn!<CR>

" {{{1 Case insensitive search shortcut
nnoremap // /\c

" {{{1 Center cursor after a half page scroll without polluting the jump list
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" {{{1 Add large j and k movements to the jump list
nnoremap <expr> k (v:count >= 5 ? "m'" . v:count : '') . 'gk'
nnoremap <expr> j (v:count >= 5 ? "m'" . v:count : '') . 'gj'

" {{{1 Quicker access to the black hole register
nmap _ "_

" {{{1 Plugin Mappings

" {{{2 Telescope
nnoremap <leader>ff <cmd>lua require("telescope.builtin").find_files()<CR>
nnoremap <leader>fg <cmd>lua require("telescope.builtin").live_grep()<CR>
nnoremap <leader>fb <cmd>lua require("telescope.builtin").buffers()<CR>
nnoremap <leader>fh <cmd>lua require("telescope.builtin").help_tags()<CR>
" {{{2 easy motion

" {{{3 Global mapping
map <leader>; <Plug>(easymotion-next)
map <leader>, <Plug>(easymotion-prev)

" {{{3 Multi line
map <leader>f <Plug>(easymotion-bd-f)
map <leader>t <Plug>(easymotion-bd-t)
map <leader>b <Plug>(easymotion-bd-t2)
map s         <Plug>(easymotion-s2)

" {{{3 Multi line Overwindows
nmap <leader>wl <Plug>(easymotion-overwin-line)

" {{{2 Limelight
nmap <leader>lt <Plug>(Limelight)
xmap <leader>lt <Plug>(Limelight)
nnoremap <silent> <leader>l :Limelight!!<CR>
" {{{2 Harpoon
nmap <leader>gg <cmd>lua require('harpoon.ui').toggle_quick_menu()<CR>
nmap <leader>ga :lua require("harpoon.mark").add_file()<CR>
nmap <leader>gn :lua require("harpoon.ui").nav_file(1)<CR>
nmap <leader>ge :lua require("harpoon.ui").nav_file(2)<CR>
nmap <leader>gi :lua require("harpoon.ui").nav_file(3)<CR>
" {{{2
nmap S <Plug>Ysurround
" {{{2 fugitive
nnoremap <F1> :tab Git<CR>
" {{{2 vim-maximizer
noremap <C-w><C-m> :MaximizerToggle<CR>
" {{{2 vim-easy-align
vmap ga <Plug>(EasyAlign)
