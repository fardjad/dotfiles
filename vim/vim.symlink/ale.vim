let g:ale_lint_on_save=1
let g:ale_fix_on_save=1
let g:ale_lint_on_text_changed=0

" javascript
let g:ale_fixers={
            \ 'javascript': ['eslint']
            \ }

" key maps
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
