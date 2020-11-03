function! s:InfoView()
    if getwininfo(get(g:, "coc_last_float_win", -1)) == []
        call CocAction('doHover')
    endif
endfunction

autocmd! CursorHoldI <buffer> silent call <SID>InfoView()

setlocal textwidth=100

let b:switch_definitions = [
    \ g:switch_builtins.true_false,
    \ ["#check", "#reduce", "#eval", "#print"],
    \ ["squeeze_simp", "simp only [", "simp"],
    \ ["cases", "rcases", "obtain"],
    \ ["tt", "ff"],
    \ ["=", "≠"],
    \ ["∈", "∉"],
    \ ["×", "→"],
    \ ["0", "₀", "⁰"],
    \ ["1", "₁", "¹"],
    \ ["2", "₂", "²"],
    \ ["3", "₃", "³"],
    \ ["4", "₄", "⁴"],
    \ ["5", "₅", "⁵"],
    \ ["6", "₆", "⁶"],
    \ ["7", "₇", "⁷"],
    \ ["8", "₈", "⁸"],
    \ ["9", "₉", "⁹"],
\ ]
