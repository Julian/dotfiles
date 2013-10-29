if !exists("*textobj#user#plugin")
    finish
endif

call textobj#user#plugin('call', {
\   'call': {
\     'pattern': ['\<\i\+(', ')'],
\     'select-a': 'ac',
\     'select-i': 'ic',
\   },
\ })
