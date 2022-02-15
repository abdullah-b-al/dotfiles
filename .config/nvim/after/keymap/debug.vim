function! ToggleDebugMappings()
    if match(&filetype, "\.debug") >= 0
        nnoremap <localleader>R  :call vimspector#Restart()<CR>
        nnoremap <localleader>r  :call vimspector#Reset()<CR>
        nnoremap <localleader>sO :call vimspector#StepOut()<CR>
        nnoremap <localleader>so :call vimspector#StepOver()<CR>
        nnoremap <localleader>si :call vimspector#StepInto()<CR>
        nnoremap <localleader>C  :call vimspector#Continue()<CR>
        nnoremap <localleader>c  :call vimspector#RunToCursor()<CR>
        nnoremap <localleader>B  :call vimspector#ToggleAdvancedBreakpoint()<CR>
        nnoremap <localleader>b  :call vimspector#ToggleBreakpoint()<CR>
    else
        silent! unmap <localleader>r
        silent! unmap <localleader>R
        silent! unmap <localleader>so
        silent! unmap <localleader>sO
        silent! unmap <localleader>si
        silent! unmap <localleader>C
        silent! unmap <localleader>c
        silent! unmap <localleader>B
        silent! unmap <localleader>b
    end
endfunction

function! ToggleDebugFileType()
    if match(&filetype, "\.debug") >= 0
        set filetype-=.debug
    else
        set filetype+=.debug
    endif
    call ToggleDebugMappings()
endfunction

nnoremap <F11> :call ToggleDebugFileType()<CR>
nnoremap <leader>db :call vimspector#Launch()<CR>
