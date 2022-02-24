" {{{1 Toggle spell on and off
nmap <silent> <F12> :set spell!<CR>

" {{{1 Resource init.lua
if exists(':PackerCompile')
  nnoremap <F5> :source ~/.config/nvim/init.lua<CR>:PackerCompile<CR>
else
  nnoremap <F5> :source ~/.config/nvim/init.lua<CR>:echo "Reloaded configs but :PackerCompile isn't here"<CR>
endif
" {{{1 Map ,, to find previous char without triggering other localleader commands
nnoremap <silent> <localleader>, :norm ,<CR>

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
" nnoremap <C-d> <C-d>zz
" nnoremap <C-u> <C-u>zz

" {{{1 Add large j and k movements to the jump list
nnoremap <expr> k (v:count >= 5 ? "m'" . v:count : '') . 'gk'
nnoremap <expr> j (v:count >= 5 ? "m'" . v:count : '') . 'gj'

" {{{1 Quicker access to the black hole register
nmap _ "_

