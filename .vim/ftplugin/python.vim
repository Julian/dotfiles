let python_highlight_all=1

let g:pyindent_open_paren = '&sw'
let g:pyindent_continue = '&sw'

setlocal omnifunc=jedi#completions

let b:switch_definitions = [
    \ ["assertAlmostEqual", "assertNotAlmostEqual"],
    \ ["assertEqual", "assertNotEqual"],
    \ ["assertIn", "assertNotIn"],
    \ ["assertIsInstance", "assertNotIsInstance"],
    \ ["assertRegexpMatches", "assertNotRegexpMatches"],
    \ ["min", "max"],
    \ ["in", "not in"],
    \ ["==", "!="],
\ ]

let s:python = substitute(system('which python || which pypy'), '\n', '', '')
let s:condent = system('which condent')
if !v:shell_error
    let s:condent = substitute(s:condent, '\n', '', '')
    exec 'setlocal equalprg=' . s:python . '\ ' . s:condent
endif

setlocal errorformat=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
setlocal makeprg=python\ %

setlocal matchpairs-=<:>
let b:delimitMate_nesting_quotes = ['"']
let b:delimitMate_expand_cr = 1

nnoremap <buffer> gd :YcmCompleter GoToDeclaration<CR>
nnoremap <buffer> [d :YcmCompleter GoToDefinitionElseDeclaration<CR>

function! Reindent(delimiter)
    execute "normal! va" . a:delimiter . "o"
    normal! ?\i*
    normal! o
    normal! =
    normal! ']
endfunction

" Make inserting closing delimiters automatically reindent the container and
" move to the end again
" inoremap <buffer> } }<C-G>u<C-O>:call Reindent('}')<CR><Right>
" inoremap <buffer> ] ]<C-G>u<C-O>:call Reindent(']')<CR><Right>
" inoremap <buffer> ) )<C-G>u<C-O>:call Reindent(')')<CR><Right>

nmap <buffer> <silent><Leader>jf <Esc>:Pytest file<CR>
nmap <buffer> <silent><Leader>jc <Esc>:Pytest class<CR>
nmap <buffer> <silent><Leader>jm <Esc>:Pytest method<CR>

nmap <buffer> <silent><Leader>jn <Esc>:Pytest next<CR>
nmap <buffer> <silent><Leader>jp <Esc>:Pytest previous<CR>
nmap <buffer> <silent><Leader>je <Esc>:Pytest error<CR>

" a / d
"       foo.bar.baz <=> foo["bar"]["baz"]
" f / i
"       from foo import bar <=> import foo
nmap <buffer> <silent><LocalLeader>a F[i.<Esc>lds]ds"ds'
nmap <buffer> <silent><LocalLeader>d T.Xysw]lysiw"
nmap <buffer> <silent><LocalLeader>f :s/^import \(\i*\)/from \1 import /<CR>$
nmap <buffer> <silent><LocalLeader>i :s/^from \(\i*\) import .*/import \1/<CR>

vmap <buffer> <silent><LocalLeader>' :s/'/"<CR>

" --------------------- from here on requires +python -------------------------
if !has("python")
    finish
endif

" Add support for virtualenvs
python << EOF
import os
import sys
import vim

virtualenv = os.environ.get("VIRTUAL_ENV")
if virtualenv is not None:
    sys.path.insert(0, virtualenv)
    activate_this = os.path.join(virtualenv, 'bin/activate_this.py')
    execfile(activate_this, dict(__file__=activate_this))
EOF
