set laststatus=0
set noruler

set spell
set textwidth=0
set wrap

" Display lines make a bit more sense to me for this use case.
nnoremap j gj
nnoremap k gk
nnoremap $ g$
nnoremap <Up> k
nnoremap <Down> j
nnoremap <Right> $

autocmd FocusLost * ++nested write
autocmd InsertLeave * ++nested write

noremap <D-a> ggVG
inoremap <D-a> <C-o>gg<C-o>VG
noremap <D-v> "*p
inoremap <D-v> <C-o>"*p

startinsert
