if has("gui_gtk2")
    set guifont=Inconsolata\ 14,Terminus\ 14,Consolas\ 14
elseif has("gui_photon")
    set guifont=Inconsolata:s14,Terminus:s14,Consolas:s14
elseif has("x11")
    set guifont=-*-inconsolata-medium-r-normal-*-*-180-*-*-m-*-*
    set guifont+=-*-terminus-medium-r-normal-*-*-180-*-*-m-*-*
    set guifont+=-*-consolas-medium-r-normal-*-*-180-*-*-m-*-*
elseif has("gui_macvim")
    set fuoptions=maxvert,maxhorz
    au GUIEnter * set fullscreen
    set guifont=Inconsolata:h14,Terminus:h14,Monaco:h14,Consolas:h14
endif


set guioptions-=T
set guioptions-=L
set guioptions-=m
set guioptions-=r

colorscheme jellybeans
