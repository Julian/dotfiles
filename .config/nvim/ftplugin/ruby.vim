setlocal shiftwidth=2
setlocal softtabstop=2

let b:use_single_quotes = 1

imap <buffer> <C-l> <space>=><space>

map <buffer> <F9> :!ruby "%:p"<CR>
