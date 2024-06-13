if !exists("g:loaded_switch")
    finish
endif

let g:switch_custom_definitions = [
    \ ['-', '+'],
    \ ['*', '/'],
    \ ["==", "!="],
    \ switch#NormalizedCase(['min', 'max']),
    \ switch#NormalizedCaseWords(['or', 'and']),
    \ switch#NormalizedCaseWords(['top', 'bottom']),
    \ switch#NormalizedCaseWords(['left', 'right']),
    \ switch#NormalizedCaseWords(['width', 'height']),
    \ switch#NormalizedCaseWords(['yes', 'no']),
\ ]
