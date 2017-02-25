if !exists("g:loaded_denite") || !g:loaded_denite
    finish
endif

if has("autocmd")
    call denite#custom#option('default', 'prompt', '» ')

    if executable('rg')
        call denite#custom#var('file_rec', 'command',
            \ ['rg', '--follow',
            \        '--color', 'never', '--no-heading', '--files'])
        call denite#custom#var('grep', 'command', 'rg')
        call denite#custom#var('grep', 'default_opts',
            \ ['-i', '--vimgrep', '--hidden', '--no-heading'])
        call denite#custom#var('grep', 'recursive_opts', [])
    elseif executable('l')
        call denite#custom#var('file_rec', 'command', ['l', '-1', '-R', '-A'])
    endif

    call denite#custom#filter(
      \ 'matcher_ignore_globs', 'ignore_globs', split(&wildignore, ','))
endif

