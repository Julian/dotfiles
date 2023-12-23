if !exists(":RainbowParenthesesToggle")
    finish
endif

if has("autocmd")
    augroup rainbowparentheses
        autocmd!
        autocmd VimEnter * RainbowParenthesesToggle
        autocmd Syntax * RainbowParenthesesLoadRound
        autocmd Syntax * RainbowParenthesesLoadSquare
        autocmd Syntax * RainbowParenthesesLoadBraces
    augroup END
endif
