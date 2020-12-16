if !exists("g:did_coc_loaded") || !g:did_coc_loaded
    finish
endif

inoremap <silent><expr> <Tab>
      \ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
      \ pumvisible() ? coc#_select_confirm() :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-Tab> pumvisible() ? "\<C-p>" : "\<C-h>"

let g:coc_snippet_next = '<tab>'

if exists('*complete_info')
  inoremap <expr> <Plug>CocCR complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  inoremap <expr> <Plug>CocCR pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif
" vim-endwise + coc
imap <CR> <Plug>CocCR<Plug>DiscretionaryEnd

nmap <silent> gd <Plug>(coc-definition)
nnoremap <silent> K :call CocAction('doHover')<CR>

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction
