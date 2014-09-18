let g:syntastic_error_symbol="✖"
let g:syntastic_warning_symbol="✦"
let g:syntastic_mode_map = {
            \ "mode" : "passive",
            \ "active_filetypes" : ["python"],
            \ }

let g:syntastic_python_checkers = ['pyflakes']
