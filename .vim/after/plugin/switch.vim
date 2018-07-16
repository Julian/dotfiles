if !exists("g:loaded_switch")
    finish
endif

let g:switch_custom_definitions = [
    \ ['-', '+'],
    \ ['*', '/'],
    \ switch#NormalizedCase(['or', 'and']),
    \ switch#NormalizedCase(['yes', 'no']),
    \ switch#NormalizedCase(['width', 'height']),
\ ]
