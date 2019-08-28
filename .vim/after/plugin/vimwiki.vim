if !exists("g:loaded_vimwiki") || !g:loaded_vimwiki
    finish
endif

let g:vimwiki_list = [
    \ {'path': '~/.local/share/vimwiki/', 'syntax': 'markdown', 'ext': '.md'},
    \ ]
