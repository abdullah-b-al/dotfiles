let g:lightline = { 'colorscheme': 'powerline' }

let g:lightline.active = {
            \ 'left': [ [ 'paste' ],
            \           [ 'readonly', 'filename', 'modified' ] ],
            \ 'right': [ [ 'lineinfo' ],
            \            [ 'percent' ],
            \            [ 'fileformat', 'fileencoding', 'filetype' ] ] }
