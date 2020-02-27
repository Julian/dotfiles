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
    nnoremap <silent><buffer><expr> d denite#do_map('do_action', 'delete')
    nnoremap <silent><buffer><expr> T denite#do_map('do_action', 'tabopen')
    nnoremap <silent><buffer><expr> v denite#do_map('do_action', 'vsplit')
    nnoremap <silent><buffer><expr> h denite#do_map('do_action', 'split')
    nnoremap <silent><buffer><expr> p denite#do_map('do_action', 'preview')
    nnoremap <silent><buffer><expr> q denite#do_map('quit')
    nnoremap <silent><buffer><expr> i denite#do_map('open_filter_buffer')
    nnoremap <nowait> <silent><buffer><expr> y denite#do_map('do_action', 'yank')
    nnoremap <silent><buffer><expr> c denite#do_map('do_action', 'cd')
    nnoremap <silent><buffer><expr> e denite#do_map('do_action', 'edit')
    nnoremap <nowait> <silent><buffer><expr> o denite#do_map('do_action', 'drop')
    nnoremap <silent><buffer><expr> V denite#do_map('toggle_select')
    nnoremap <silent><buffer><expr> <space> denite#do_map('toggle_select').'j'

   " I am not sure how to remap this now, previous denite functions are gone
    nnoremap <silent><buffer> s j
    nnoremap <silent><buffer> r k
endfunction

autocmd FileType denite-filter call s:denite_filter_my_settings()
function! s:denite_filter_my_settings() abort
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

    imap <silent><buffer> <C-g> <Plug>(denite_filter_quit)
    inoremap <silent><buffer><expr> <CR> denite#do_map('do_action')
    inoremap <silent><buffer><expr> <tab> denite#do_map('choose_action')
    inoremap <silent><buffer><expr> <c-t> denite#do_map('do_action', 'tabopen')
    inoremap <silent><buffer><expr> <c-v> denite#do_map('do_action', 'vsplit')
    inoremap <silent><buffer><expr> <c-s> denite#do_map('do_action', 'split')
    inoremap <silent><buffer><expr> <c-o> denite#do_map('do_action', 'drop')
    inoremap <silent><buffer><expr> <esc> denite#do_map('quit')
    inoremap <silent><buffer> <C-n> <Esc><C-w>p:call cursor(line('.')+1,0)<CR><C-w>pA
    inoremap <silent><buffer> <C-p> <Esc><C-w>p:call cursor(line('.')-1,0)<CR><C-w>pA
endfunction

if executable('rg')
    call denite#custom#var('file/rec', 'command',
        \ ['rg', '--follow', '--hidden',
        \        '--color', 'never', '--no-heading', '--files'])
    call denite#custom#var('grep', 'command', ['rg'])
    call denite#custom#var('grep', 'default_opts',
        \ ['--smart-case', '--vimgrep', '--hidden', '--heading'])
    call denite#custom#var('grep', 'recursive_opts', [])
    call denite#custom#var('grep', 'pattern_opt', ['--regexp'])
    call denite#custom#var('grep', 'separator', ['--'])
    call denite#custom#var('grep', 'final_opts', [])
elseif executable('l')
    call denite#custom#var('file/rec', 'command', ['l', '-1', '-R', '-A'])
endif
