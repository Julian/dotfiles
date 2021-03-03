setlocal makeprg=tree-sitter\ generate\ &&\ tree-sitter\ test

setlocal shiftwidth=2
setlocal softtabstop=2

nnoremap <buffer> <localleader>_ yypVr-
nnoremap <buffer> <localleader>+ yypVr=

nnoremap <buffer> <localleader>- yyPVr-yyjp
nnoremap <buffer> <localleader>= yyPVr=yyjp
