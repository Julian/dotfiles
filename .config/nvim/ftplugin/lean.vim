function! s:InfoView()
    if getwininfo(get(g:, "coc_last_float_win", -1)) == []
        call CocAction('doHover')
    endif
endfunction

set updatetime=350
autocmd CursorHold <buffer> silent call <SID>InfoView()
