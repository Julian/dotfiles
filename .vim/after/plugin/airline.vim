if !exists("g:loaded_airline") || !g:loaded_airline
    finish
endif

let g:airline_left_sep = '»'
let g:airline_right_sep = '«'
let g:airline_linecolumn_prefix = '␤ '
let g:airline_branch_prefix = '⎇ '
" We have Syntastic lazy-loaded which makes airline unhappy.
let g:airline#extensions#syntastic#enabled = 0

let g:airline#extensions#default#section_truncate_width = {
    \ 'b': 0,
    \ 'x': 60,
    \ 'y': 88,
    \ 'z': 45,
    \ }
