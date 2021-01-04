function! s:InfoView()
    if getwininfo(get(g:, "coc_last_float_win", -1)) == []
        call CocAction('doHover')
    endif
endfunction

autocmd! CursorHoldI <buffer> silent call <SID>InfoView()
