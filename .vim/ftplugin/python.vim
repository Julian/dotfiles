let python_highlight_all=1

set omnifunc=pythoncomplete#Complete

let s:python = substitute(system('which pypy || which python'), '\n', '', '')
let s:condent = substitute(system('which condent'), '\n', '', '')
exec 'set equalprg=' . s:python . '\ ' . s:condent

set indentkeys-=<:>,0#
set errorformat=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

" Make inserting closing delimiters automatically reindent the container and
" move to the end again
inoremap <buffer> } }u=a}/}<CR><Right>
inoremap <buffer> ] ]u=a]/]<CR><Right>
inoremap <buffer> ) )u=a)/)<CR><Right>
