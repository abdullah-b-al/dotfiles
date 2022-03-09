" commands
command! W :w


" auto-commands
autocmd FileType c,cpp,lua Minimap

" augrops
augroup AutoSaveFolds
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

