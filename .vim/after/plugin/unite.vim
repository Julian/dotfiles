if !exists("g:loaded_unite") || !g:loaded_unite
    finish
endif

if has("autocmd")
    let g:unite_data_directory=expand("$XDG_CACHE_HOME/vim/unite")
    let g:unite_enable_start_insert = 1
    let g:unite_prompt='» '

    call unite#filters#matcher_default#use(['matcher_fuzzy'])
    call unite#filters#sorter_default#use(['sorter_rank'])

    call unite#custom_source('file_rec,file_rec/async,file_mru,file,buffer,grep',
          \ 'ignore_pattern',
          \ escape(
          \     substitute(join(split(&wildignore, ","), '\|'), '**/\?', '', 'g'),
          \     '.'))

    function! <SID>Unite_Settings()
        map <silent><buffer> <Esc><Esc> <Plug>(unite_exit)
        imap <silent><buffer> <Esc><Esc> <Plug>(unite_exit)

        silent! iunmap <buffer><C-H>
        silent! iunmap <buffer><BS>
    endfunction

    augroup unite
        autocmd!
        autocmd FileType unite call <SID>Unite_Settings()
    augroup END
endif

