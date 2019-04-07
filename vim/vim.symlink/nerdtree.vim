" NERDTree

" open NERDTree automatically when no file is specified
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" toggle NERDTree with Ctrl+/
" http://stackoverflow.com/questions/9051837/how-to-map-c-to-toggle-comments-in-vim
map <C-_> :NERDTreeToggle<CR>

" close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
let NERDTreeHijackNetrw=0
