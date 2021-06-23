if !exists("g:loaded_denite") || !g:loaded_denite
    finish
endif

let s:denite_options = {
    \ 'auto_resize': 1,
    \ 'direction': 'dynamicbottom',
    \ 'prompt' : '» ',
    \ 'source_names': 'short',
    \ 'split': 'floating',
    \ 'start_filter': 1,
    \ 'vertical_preview': 1,
    \ 'winrow': 1,
    \ }
call denite#custom#option('default', s:denite_options)

autocmd FileType denite call s:denite_my_settings()
function! s:denite_my_settings() abort
    if exists("g:loaded_compe") && g:loaded_compe
        call compe#setup({'enabled': v:false}, 0)
    endif

    call denite#custom#map(
            \ 'insert',
            \ '<C-n>',
            \ '<denite:move_to_next_line>',
            \ 'noremap'
            \)
    call denite#custom#map(
            \ 'insert',
            \ '<C-p>',
            \ '<denite:move_to_previous_line>',
            \ 'noremap'
            \)

    nnoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
    nnoremap <silent><buffer><expr> <tab> denite#do_map('choose_action')
    nnoremap <silent><buffer><expr> q denite#do_map('quit')

   " I am not sure how to remap this now, previous denite functions are gone
    nnoremap <silent><buffer> s j
    nnoremap <silent><buffer> r k
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
    if exists("g:loaded_compe") && g:loaded_compe
        call compe#setup({'enabled': v:false}, 0)
    endif

    call denite#custom#map(
            \ 'insert',
            \ '<C-n>',
            \ '<denite:move_to_next_line>',
            \ 'noremap'
            \)
    call denite#custom#map(
            \ 'insert',
            \ '<C-p>',
            \ '<denite:move_to_previous_line>',
            \ 'noremap'
            \)

    inoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
    inoremap <silent><buffer><expr> <tab> denite#do_map('choose_action')
    inoremap <silent><buffer><expr> <esc> denite#do_map('quit')
    inoremap <silent><buffer> <C-n> <Esc><C-w>p:call cursor(line('.')+1,0)<CR><C-w>pA
    inoremap <silent><buffer> <C-p> <Esc><C-w>p:call cursor(line('.')-1,0)<CR><C-w>pA
endfunction

if executable('rg')
    call denite#custom#var('file/rec', 'command',
        \ ['rg', '--follow', '--hidden',
        \        '--color', 'never', '--no-heading', '--files',
        \        '--glob', '!.hg',
        \ ])
    call denite#custom#var('grep', {
            \ 'command': ['rg'],
            \ 'default_opts': ['--smart-case', '--vimgrep', '--hidden', '--no-heading'],
            \ 'recursive_opts': [],
            \ 'pattern_opt': ['--regexp'],
            \ 'separator': ['--'],
            \ 'final_opts': [],
            \ })
elseif executable('l')
    call denite#custom#var('file/rec', 'command', ['l', '-1', '-R', '-A'])
endif
