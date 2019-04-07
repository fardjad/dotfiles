let g:EasyMotion_do_mapping=0 " Disable default mappings

" Bi-directional find motion
" `s{char}{char}{label}`
nmap <Leader>s <Plug>(easymotion-s2)

" Case insensitive search
let g:EasyMotion_smartcase=1

" JK motions: Line motions
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)
