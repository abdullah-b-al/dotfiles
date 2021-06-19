" Map leader to which_key
nnoremap <silent> <leader> :silent WhichKey '<Space>'<CR>
vnoremap <silent> <leader> :silent <c-u> :silent WhichKeyVisual '<Space>'<CR>

" Create map to add keys to
let g:which_key_map =  {}
" Define a separator
let g:which_key_sep = '→'
 


let g:which_key_use_floating_win = 0

" Change the colors if you want
highlight default link WhichKey          Operator
highlight default link WhichKeySeperator DiffAdded
highlight default link WhichKeyGroup     Identifier
highlight default link WhichKeyDesc      Function

" Hide status line
autocmd! FileType which_key
autocmd  FileType which_key set laststatus=0 noshowmode noruler
  \| autocmd BufLeave <buffer> set laststatus=2 noshowmode ruler

" Single mappings
" let g:which_key_map['/'] = [ '<Plug>NERDCommenterToggle'  , 'comment' ]
" let g:which_key_map['e'] = [ ':CocCommand explorer'       , 'explorer' ]
" let g:which_key_map['f'] = [ ':Files'                     , 'search files' ]
" let g:which_key_map['h'] = [ '<C-W>s'                     , 'split below']
" let g:which_key_map['r'] = [ ':Ranger'                    , 'ranger' ]
" let g:which_key_map['S'] = [ ':Startify'                  , 'start screen' ]
" let g:which_key_map['T'] = [ ':Rg'                        , 'search text' ]
" let g:which_key_map['v'] = [ '<C-W>v'                     , 'split right']
" let g:which_key_map['z'] = [ 'Goyo'                       , 'zen' ]

" Group Template
" let g:which_key_map. = {
"     \ 'name' : '' ,
"     \ ''  : ['', ''], 
" \ }

let g:which_key_map.fn = {
    \ 'name'  : '+Mappings Inside Fern', 
    \ 'o'     : ['', 'Open'], 
    \ 'sp'    : ['', 'Horizontal split'], 
    \ 'vs'    : ['', 'Vertical split'], 
    \ 'gs'    : ['', 'sp + go back to fern'], 
    \ 'gv'    : ['', 'vs + go back to fern'], 
    \ 'r'     : ['', 'reload'], 
    \ 'q'     : ['', 'quit'], 
    \ }

let g:which_key_map.f = {
    \ 'name' : '+Fern Commands',
    \ 'F'    : [':FernDo close'         , 'close fern'],
    \ 'h'    : [':Fern $HOME -drawer'   , 'open fern @ home dir'],
    \ 'p'    : [':Fern %:h -drawer'     , 'open fern @ parent dir'],
    \ 'f'    : [':Fern . -drawer'       , 'open fern @ working dir'],
    \ }
" Register which key map
call which_key#register('<Space>', "g:which_key_map")
