let python_highlight_all=1

setlocal omnifunc=pythoncomplete#Complete

let s:python = substitute(system('which pypy || which python'), '\n', '', '')
let s:condent = substitute(system('which condent'), '\n', '', '')
exec 'setlocal equalprg=' . s:python . '\ ' . s:condent

setlocal errorformat=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

function! Reindent(delimiter)
    execute "normal! va" . a:delimiter . "o"
    normal! ?\i*
    normal! o
    normal! =
    normal! ']
endfunction

" Make inserting closing delimiters automatically reindent the container and
" move to the end again
inoremap <buffer> } }<C-G>u<C-O>:call Reindent('}')<CR><Right>
inoremap <buffer> ] ]<C-G>u<C-O>:call Reindent(']')<CR><Right>
inoremap <buffer> ) )<C-G>u<C-O>:call Reindent(')')<CR><Right>

nmap <silent><Leader>jf <Esc>:Pytest file<CR>
nmap <silent><Leader>jc <Esc>:Pytest class<CR>
nmap <silent><Leader>jm <Esc>:Pytest method<CR>

nmap <silent><Leader>jn <Esc>:Pytest next<CR>
nmap <silent><Leader>jp <Esc>:Pytest previous<CR>
nmap <silent><Leader>je <Esc>:Pytest error<CR>

map <buffer> gd :RopeGotoDefinition<CR>

map <buffer> <F9> :!python "%:p"<CR>

" --------------------- from here on requires +python -------------------------
if !has("python")
    finish
endif

" Add support for virtualenvs
python << EOF
import os
import sys
import vim

virtual_env = os.environ.get("VIRTUAL_ENV")
if virtual_env is not None:
    sys.path.insert(0, virtual_env)
    activate_this = os.path.join(virtual_env, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
