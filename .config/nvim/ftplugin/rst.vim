setlocal makeprg=rst2html.py\ %

" Leaving these here for now even though UltiSnips has snippets for them too
nnoremap <buffer> <localleader>_ yypVr-
nnoremap <buffer> <localleader>+ yypVr=

nnoremap <buffer> <localleader>- yyPVr-yyjp
nnoremap <buffer> <localleader>= yyPVr=yyjp
