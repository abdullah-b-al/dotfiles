syntax on
filetype plugin on

set mouse=a

set nocompatible
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set nu
set nowrap
set smartcase
set incsearch
set	rtp+=~/.config/vim " add XDG_CONGIF_HOME to runtime path
set number relativenumber
set spell
set dictionary?
set dictionary+=/usr/share/dict/words
set spellfile=~/.config/vim/spell/en.utf-8.add 
set updatetime=1000


colorscheme focuspoint


let &t_SI = "\<esc>[5 q"   " blinking I-beam in insert mode
let &t_SR = "\<esc>[3 q"   " blinking underline in replace mode
let &t_EI = "\<esc>[ q"    " default cursor (usually blinking block) otherwise

let g:auto_save = 1        " enable AutoSave on Vim startup"

nnoremap <SPACE> <Nop>
map <Space> <Leader>

"""""""""" Swap cursor movement keys for colemak
noremap n j
noremap j n
""""""""""

let g:asyncomplete_enable_for_all = 1

"""""""""" Terminal mode setting for NeoVim
tnoremap <Esc> <C-\><C-n>


"""""""""" AutoSave Settings
let g:auto_save_events = ["InsertLeave", "CursorHold"]


call plug#begin('~/.config/vim/plugged')
    Plug 'ap/vim-css-color' 
    Plug 'vimwiki/vimwiki'
    Plug 'romainl/vim-cool'      " disables search highlighting when you are done searching and re-enables it when you search again. 
    Plug 'lfilho/cosco.vim'      " Comma and semi-colon insertion
    Plug '907th/vim-auto-save'  
    Plug 'scrooloose/syntastic'
    Plug 'vim-scripts/c.vim'     " C IDE
    Plug 'tpope/vim-surround'
    Plug 'lifepillar/vim-cheat40'
    Plug 'joom/vim-commentary'
    Plug 'christoomey/vim-system-copy'
    Plug 'michaeljsmith/vim-indent-object'
    Plug 'jiangmiao/auto-pairs'
    Plug 'itchyny/lightline.vim'
"	Plug 'neoclide/coc.nvim', {'branch': 'release'}

" LSP plugins
    Plug 'prabirshrestha/vim-lsp'
    Plug 'mattn/vim-lsp-settings'
    Plug 'prabirshrestha/asyncomplete.vim'
    Plug 'prabirshrestha/asyncomplete-lsp.vim'

" Fern filemanager
	Plug 'lambdalisue/fern.vim'
	Plug 'lambdalisue/nerdfont.vim'
	Plug 'lambdalisue/fern-renderer-nerdfont.vim'
	Plug 'lambdalisue/glyph-palette.vim'

call plug#end()

"""""""""" Cosco Settings
autocmd FileType c nmap <silent> <Leader>; <Plug>(cosco-commaOrSemiColon)
"noremap " A;

source $HOME/.config/vim/Plugins\ Configs/asyncomplete_config.vim
source $HOME/.config/vim/Plugins\ Configs/syntastic_config.vim
" source $HOME/.config/vim/Plugins\ Configs/coc_config.vim
source $HOME/.config/vim/Plugins\ Configs/fern_config.vim
