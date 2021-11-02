let g:VimuxHeight = "50"
let g:VimuxCloseOnExit = 1

nmap <F3> :VimuxTogglePane<CR>
nmap <F4> :VimuxInspectRunner<CR>
nmap <F7> :VimuxZoomRunner<CR>

autocmd FileType zig nmap <buffer> <F8> :VimuxClearTerminalScreen<CR>:VimuxRunCommand "zig build"<CR>
autocmd FileType c   nmap <buffer> <F8> :VimuxClearTerminalScreen<CR>:VimuxRunCommand "make"<CR>
