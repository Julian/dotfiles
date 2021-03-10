setlocal makeprg=tree-sitter\ generate\ &&\ tree-sitter\ test

setlocal shiftwidth=2
setlocal softtabstop=2

nnoremap <buffer> <localleader>- o<CR>---<CR><CR><Esc>
nnoremap <buffer> <localleader>= yyPVr=yyjp
