augroup AutoSaveFolds
    autocmd!
    autocmd BufWinEnter * silent! loadview
    autocmd BufWinLeave * silent! mkview
augroup END

augroup SpellIgnore
    autocmd BufWinEnter,VimEnter * if filewritable(expand('%')) == 1 && &modifiable == 1 | :set spell | else | :set nospell | endif
augroup END
