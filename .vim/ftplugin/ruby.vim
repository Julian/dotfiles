setlocal shiftwidth=2
setlocal softtabstop=2

let b:preferred_quote_char = "'"


imap <buffer> <C-l> <space>=><space>

map <buffer> <F9> :!ruby "%:p"<CR>
