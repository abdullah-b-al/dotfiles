colo PerfectDark
set colorcolumn=80

" Disable colorcolumn for certain file types
autocmd FileType markdown,txt,netrw set colorcolumn=0

autocmd vimenter,ColorScheme * highlight! MatchParen guifg=#FF0000 guibg=#202020 gui=NONE ctermfg=196 ctermbg=233 cterm=reverse
" make nvim transparent in ST
" autocmd vimenter,ColorScheme * hi Normal guibg=NONE ctermbg=NONE
