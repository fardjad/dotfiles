" compatibility options
set nocompatible

" disable word-wrap
set nowrap

" line numbers
set number

" change leader to ,
let mapleader=','

" disable the annoying bell
set vb
set t_vb=

" enable mouse
set mouse=a

" toggle paste mode with F2
" http://vim.wikia.com/wiki/Toggle_auto-indenting_for_code_paste
nnoremap <F2> :set invpaste paste?<CR>
set pastetoggle=<F2>
set showmode

" use system clipboard
set clipboard=unnamed,unnamedplus
set spelllang=en_us

" spell checking
" only spellcheck comments
syntax spell toplevel
" toggle spellchecking by pressing <leader> sc 
map <leader>sc :setlocal spell!<CR>

" better buffer management
" allow switching buffers without writing the changes
set hidden
" switch buffers with F12 and S-F12
nnoremap <silent> <F12> :bn<CR>
nnoremap <silent> <S-F12> :bp<CR>

" better search
set hlsearch
set ignorecase
set smartcase
" disable search highlighting after pressing esc twice
" http://stackoverflow.com/a/27207615
nnoremap <silent> <Esc><Esc> :let @/=""<CR>

" default indentation settings
set tabstop=4
set shiftwidth=4
set softtabstop=4
" use spaces instead of tabs
set expandtab

" set updatetime to 100ms (recommended by gitgutter plugin author)
set updatetime=100
