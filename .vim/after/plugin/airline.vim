if !exists("g:loaded_airline") || !g:loaded_airline
    finish
endif

if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif

let g:airline_left_sep = '»'
let g:airline_right_sep = '«'
let g:airline_symbols.branch = '⎇ '
let g:airline_symbols.linenr = '¶'
" We have Syntastic lazy-loaded which makes airline unhappy.
let g:airline#extensions#syntastic#enabled = 0

let g:airline#extensions#default#section_truncate_width = {
    \ 'b': 0,
    \ 'x': 60,
    \ 'y': 88,
    \ 'z': 45,
    \ }
