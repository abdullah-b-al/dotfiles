" commands
command! W :w


" auto-commands

" augrops
augroup CommentString
  autocmd!
  autocmd BufWinEnter,BufEnter * if &ft=="cpp" | setlocal commentstring=//%s | endif
  autocmd BufWinEnter,BufEnter * if &ft=="c" | setlocal commentstring=//%s | endif
augroup END

augroup AutoOpenFolds
  autocmd!
  autocmd BufWinEnter,BufEnter * norm zR
augroup END

augroup LoadAndMakeView
  autocmd!
  autocmd BufWinEnter * silent! loadview
  autocmd BufWinLeave * silent! mkview
augroup END

augroup SpellIgnore
  autocmd BufWinEnter,VimEnter * if filewritable(expand('%')) == 1 && &modifiable == 1 | :set spell | else | :set nospell | endif
augroup END

augroup highlight_yanked
  autocmd!
  autocmd TextYankPost * silent! lua vim.highlight.on_yank{higroup="IncSearch", timeout=100}
augroup END

