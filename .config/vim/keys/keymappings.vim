" VimWiki
nmap <Leader>vw <Plug>VimwikiIndex

" easy motion mappings
    " Multi line
    map <leader>f <Plug>(easymotion-f)
    map <leader>F <Plug>(easymotion-F)
    map <leader>t <Plug>(easymotion-t)
    map <leader>T <Plug>(easymotion-T)
    map <leader>w <Plug>(easymotion-bd-w)
    map <leader>e <Plug>(easymotion-bd-e)

    nmap <leader>wf <Plug>(easymotion-overwin-f)
    nmap <leader>wl <Plug>(easymotion-overwin-line)
    nmap <leader>ww <Plug>(easymotion-overwin-w)

    " Same line
    " Override core Vim mappings
    map f <Plug>(easymotion-bd-fl)
    map t <Plug>(easymotion-bd-tl)
