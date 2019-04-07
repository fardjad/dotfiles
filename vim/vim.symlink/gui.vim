if has('gui_running')
    " make more room
    set guioptions-=m  " remove menu bar
    set guioptions-=T  " remove toolbar
    set guioptions-=r  " remove right-hand scroll bar
    set guioptions-=L  " remove left-hand scroll bar
    " set window size
    set lines=43
    set columns=132

    " Disable cursor blinking
    set guicursor+=a:blinkon0 
    if has('gui_macvim')
        set guifont=Fira\ Code:h14
    endif
endif
