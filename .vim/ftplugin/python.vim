let python_highlight_all=1

setlocal omnifunc=pythoncomplete#Complete

let s:python = substitute(system('which pypy || which python'), '\n', '', '')
let s:condent = substitute(system('which condent'), '\n', '', '')
exec 'setlocal equalprg=' . s:python . '\ ' . s:condent

setlocal errorformat=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

" Make inserting closing delimiters automatically reindent the container and
" move to the end again
inoremap <buffer> } }<C-G>u<C-O>=a}<C-O>/}<CR><Right><C-O>:nohlsearch<CR>
inoremap <buffer> ] ]<C-G>u<C-O>=a]<C-O>/]<CR><Right><C-O>:nohlsearch<CR>
inoremap <buffer> ) )<C-G>u<C-O>=a)<C-O>/)<CR><Right><C-O>:nohlsearch<CR>

map <buffer> <F9> :!python "%:p"<CR>
