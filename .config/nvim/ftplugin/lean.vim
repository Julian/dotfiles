function! s:InfoView()
    if getwininfo(get(g:, "coc_last_float_win", -1)) == []
        call CocAction('doHover')
    endif
endfunction

setlocal updatetime=350
autocmd CursorHold <buffer> silent call <SID>InfoView()

setlocal textwidth=100

let b:switch_definitions = [
    \ ["#check", "#reduce", "#eval", "#print"],
    \ ["squeeze_simp", "simp only [", "simp"],
    \ ["cases", "rcases", "obtain"],
    \ ["tt", "ff"],
    \ ["=", "≠"],
    \ ["∈", "∉"],
    \ ["×", "→"],
\ ]
