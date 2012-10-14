let python_highlight_all=1

set omnifunc=pythoncomplete#Complete

set equalprg=condent
set indentkeys-=<:>,0#

set errorformat=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

" Make inserting closing delimiters automatically reindent the container and
" move to the end again
inoremap <buffer> } }=a}/}<CR><Right>
inoremap <buffer> ] ]=a]/]<CR><Right>
inoremap <buffer> ) )=a)/)<CR><Right>
