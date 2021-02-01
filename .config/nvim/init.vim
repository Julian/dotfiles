set nomodeline

let mapleader = "\<space>"
let maplocalleader = ","

" ===========
" : Plugins :
" ===========

function! <SID>Develop(bundle, ...)
    let bundle_directory = $DEVELOPMENT . '/' . a:bundle
    if isdirectory(bundle_directory)
        let &runtimepath .= ',' . bundle_directory
    else
        if a:0
            call plug#('Julian/' . a:bundle, a:1)
        else
            call plug#('Julian/' . a:bundle)
        endif
    endif
endfunction
command! -nargs=+ Develop call <SID>Develop(<args>)

if has('vim_starting')
    source ~/.local/share/nvim/plug.vim
endif
call plug#begin(expand('~/.local/share/nvim/bundle/'))

" --- Themes ---

Plug    'gruvbox-community/gruvbox'
Plug    'joshdick/onedark.vim'

" --- Additional FileType Support ---

Plug    'guns/vim-sexp',                              {'for': 'clojure'}
Plug    'raimon49/requirements.txt.vim',              {'for': 'requirements'}
Plug    'tpope/vim-fireplace',                        {'for': 'clojure'}
Plug    'tpope/vim-leiningen',                        {'for': 'clojure'}
Plug    'tpope/vim-sexp-mappings-for-regular-people', {'for': 'clojure'}

" --- Plugins ---

Plug    'AndrewRadev/linediff.vim',          {'on': ['Linediff', 'LinediffReset']}
Plug    'AndrewRadev/splitjoin.vim'
Plug    'AndrewRadev/switch.vim'
Plug    'andymass/vim-matchup'
Plug    'bruno-/vim-vertical-move'
Plug    'dahu/vim-fanfingtastic'
Plug    'easymotion/vim-easymotion'
Plug    'godlygeek/tabular',                 {'on': 'Tabularize'}
Plug    'kien/rainbow_parentheses.vim'
Plug    'kshenoy/vim-signature'
Plug    'itchyny/lightline.vim'
Plug    'jmcantrell/vim-diffchanges',        {'on': 'DiffChangesDiffToggle'}
Plug    'liuchengxu/vista.vim',              {'on': 'Vista'}
Plug    'mhinz/vim-signify'
Plug    'mbbill/undotree'
Plug    'nathanaelkane/vim-indent-guides',   {'on': 'IndentGuidesToggle'}
Plug    't9md/vim-quickhl'
Plug    'tommcdo/vim-exchange'
Plug    'tomtom/tcomment_vim'
Plug    'tpope/vim-abolish'
Plug    'tpope/vim-endwise'
Plug    'tpope/vim-fugitive'
Plug    'tpope/vim-obsession',               {'on': 'Obsession'}
Plug    'tpope/vim-repeat'
Plug    'tpope/vim-rhubarb'
Plug    'tpope/vim-surround'
Plug    'Valloric/MatchTagAlways',           {'for': ['html', 'xhtml', 'xml', 'jinja']}
Plug    'Valodim/vim-zsh-completion'
Plug    'vimwiki/vimwiki',                   {'branch': 'dev', 'on': 'VimwikiIndex'}

Plug    'kana/vim-textobj-user'

Develop 'lean.vim'
Develop 'vim-runt'
Develop 'vim-textobj-assignment'
Develop 'vim-textobj-variable-segment'

if has('nvim-0.5')
    Develop 'lean.nvim',                     {'branch': 'main'}
    Develop 'telescope.nvim'

    Plug 'neovim/nvim-lspconfig'
    Plug 'norcalli/snippets.nvim'
    Plug 'nvim-lua/completion-nvim'
    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-lua/popup.nvim'
    Plug 'nvim-treesitter/nvim-treesitter'
    Plug 'nvim-treesitter/nvim-treesitter-textobjects'
    Plug 'stsewd/sphinx.nvim',               {'do': ':UpdateRemotePlugins'}
else
    Plug 'neoclide/coc.nvim',                {'branch': 'release'}
    Plug 'neoclide/coc-python'
endif

if executable("tmux")
    Plug 'tpope/vim-tbone'
endif

call plug#end()

" =========
" : Basic :
" =========

set gdefault
set hidden
set lazyredraw                         " no redraw during macros (much faster)
set linebreak
set report=0                           " :cmd always shows changed line count
set textwidth=79

set nowrap
let &showbreak='↪   '

set fillchars=diff:·

set pastetoggle=<F2>                   " use F2 to toggle paste mode

set isfname-==                         " remove =, which probably is an assign

set tags=.tags,tags,.git/tags;$HOME    " look up until $HOME for tags

" ============
" : Bindings :
" ============

if has("user_commands")
    " quick fingers
    command! -bang -complete=file -nargs=? E e<bang> <args>
    command! -bang -complete=file -nargs=? Sp sp<bang> <args>
    command! -bang -complete=file -nargs=? Vsp vsp<bang> <args>
    command! -bang -complete=file -nargs=? W w<bang> <args>
    command! -bang -complete=file -nargs=? WQ wq<bang> <args>
    command! -bang -complete=file -nargs=? Wq wq<bang> <args>
    command! -bang Q q<bang>
    command! -bang Qa qa<bang>
    command! -bang QA qa<bang>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    if has('nvim-0.4')
        command! -bang X x<bang>
    endif
endif

imap <CR>           <CR><Plug>DiscretionaryEnd

" testing mappings
nnoremap      <expr>d<CR>     ":SplitSensibly "       . runt#find_test_file_for(expand("%"))                                                                    .  "<CR>"
nnoremap            dK         :call                    runt#follow()                                                                                               <CR>

" Put exchange and splitjoin on s, use cl if you want that, but I rarely do.
map s <Plug>(Exchange)

nnoremap s<CR> :SplitjoinSplit<CR>
nnoremap ss :SplitjoinJoin<CR>

" don't use Ex mode, use Q for formatting
nmap Q gqap
vmap Q gq

" change Y to act like C, D
map Y y$

nnoremap : ;
nnoremap ; :
nnoremap q; q:
vnoremap : ;
vnoremap ; :

" swap ' and `
noremap ' `
noremap ` '
noremap g' g`
noremap g` g'
noremap ]' ]`
noremap ]` ]'
" sunmap ' sunmap ` sunmap g' sunmap g`

" Preserve flags for &, and add it in visual mode.
nnoremap & :&&<CR>
xnoremap & :&&<CR>

nnoremap <silent> <C-L> :nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR>:XchangeClear<CR>:LinediffReset<CR><C-L>

" make undo less drastic + prevent accidental irreversible undo
" not sure why cr one is not working
" inoremap <BS> <BS><C-G>u
" inoremap <CR> <C-G>u<CR>
" inoremap <DEL> <DEL><C-G>u
" inoremap <C-U> <C-G>u<C-U>
" inoremap <C-W> <C-G>u<C-W>

" delete a surrounding function call (which surround doesn't support OOTB)
nmap dsc :call search('\<', 'bc')<CR>dt(ds)

" quote a word
nmap <expr> yq 'ysiw' . (get(b:, 'use_single_quotes', 0) ? "'" : '"')

"       '<F2>' is set to pastetoggle
let s:all_modes_mappings = {
    \   '<F1>'  : '',
    \   '<F12>'  : ':<C-U>make',
    \
    \   '<Up>' : ':diffget<CR>[c',
    \   '<Down>' : ':diffget<CR>]c',
    \   '<Left>' : ':diffget',
    \   '<Right>' : ':diffput'
    \
    \}

for [key, value] in items(s:all_modes_mappings)
    let value = empty(value) ? '<Nop>' : value . '<CR>'
    execute 'nnoremap ' . key . ' ' . value
    execute 'inoremap ' . key . ' <C-O>' . value
    execute 'vnoremap ' . key . ' ' . value
endfor

" Leader mappings
" ---------------
"
" Here are explanations for non-self-explanatory ones:
"
"   b : paste last deletion on its own line despite it being charwise
"   n : search forward, but not anything currently displayed
"   u : undo/redo toggle
"   B : paste system clipboard on its own line despite it not having a newline
"   N : search backward, but not anything currently displayed
"   S : remove trailing whitespace
"   0 : minimize a window

nnoremap        <leader><leader>  :Denite buffer file tag<CR>
nnoremap  <expr><leader><CR>      ':autocmd BufWritePost <buffer> !' . input('command: ', '', 'shellcmd') . '<CR>'

nnoremap        <leader>b         o<C-R>"<Esc>
nnoremap        <leader>d         :<C-U>Telescope find_files hidden=yes<CR>
nnoremap        <leader>e         :<C-U>SplitSensibly<CR>:Denite file/rec:
nnoremap        <leader>f         :<C-U>Denite file/rec:`expand('%:h')`<CR>
nnoremap        <leader>h         <Cmd>lua find_symbols()<CR>
nnoremap        <leader>j         <Cmd>lua find_symbols_from_buffer()<CR>
nnoremap        <leader>k         :<C-U>Denite -input=test/test_ file/rec<CR>
nnoremap        <leader>l         :<C-U>Telescope current_buffer_fuzzy_find<CR>
nmap            <leader>m         <Plug>(quickhl-manual-this)
nnoremap  <expr><leader>o         EditFileWORD()
nnoremap        <leader>p         "*p
nnoremap        <leader>s         :<C-U>Switch<CR>

"   <leader>t mappings are for togglers
"
" Here are explanations for non-self-explanatory ones:
"
"   p : prose mode (suitable for editing longer form text)
nnoremap        <leader>ta        :<C-U>Vista!!<CR>
nnoremap        <leader>tc        :<C-U>DiffChangesDiffToggle<CR>
nnoremap        <leader>td        :<C-U>DiffThese<CR>
nnoremap        <leader>te        :<C-U>call <SID>ToggleExpando()<CR>
nnoremap        <leader>ti        :<C-U>IndentGuidesToggle<CR>
nnoremap        <leader>tl        :<C-U>set list!<CR>
nnoremap        <leader>tn        :<C-U>call <SID>ToggleNumber()<CR>
nnoremap        <leader>tp        :<C-U>setlocal formatoptions-=c<CR>:setlocal spell<CR>:setlocal wrap<CR>:setlocal textwidth=0<CR>
nnoremap        <leader>ts        :<C-U>set spell!<CR>
nnoremap        <leader>tu        :<C-U>UndotreeToggle<CR>
nnoremap        <leader>tw        :<C-U>set wrap!<CR>

nnoremap        <leader>u         :<C-U>set cpoptions+=u<CR>u:w<CR>:set cpoptions-=u<CR>
nnoremap        <leader>v         :<C-U>SplitSensibly $MYVIMRC<CR>
nnoremap        <leader>w         :<C-U>DeniteCursorWord grep:.<CR>
nnoremap        <leader>y         "*y

nnoremap        <leader>ga         :<C-U>Git difftool<CR>
nnoremap        <leader>gb         :<C-U>Git blame<CR>
nnoremap        <leader>gc         :<C-U>Git commit<CR>
nnoremap        <leader>gd         :<C-U>Gdiffsplit<CR>
nnoremap        <leader>gf         :<C-U>Git difftool -y<CR>
nnoremap        <leader>ge         :<C-U>Gedit<CR>
nnoremap        <leader>gr         :<C-U>Gread<CR>
nnoremap        <leader>gs         :<C-U>Git<CR>
nnoremap        <leader>gw         :<C-U>Gwrite<CR>

nnoremap        <leader>B         o<C-R>*<Esc>
nnoremap  <expr><leader>C         ":<C-U>SplitSensibly<CR>:Denite -input=. file:$HOME file/rec:" . $XDG_CONFIG_HOME . "<CR>"
nmap            <leader>M         <Plug>(quickhl-manual-reset)
nnoremap        <leader>P         "*P
nnoremap        <leader>S         :<C-U>%s/\s\+$//<cr>:let @/=''<CR>
nnoremap        <leader>U         :<C-U>PlugUpdate<CR>:TSUpdate<CR>
nnoremap  <expr><leader>V         ":<C-U>SplitSensibly " . fnamemodify(expand("$MYVIMRC"), ":h") . '/lua/config/init.lua' . "<CR>"
nnoremap        <leader>Y         "*y$
nnoremap        <leader>Z         :<C-U>SplitSensibly $ZDOTDIR/.zshrc<CR>

nnoremap        <leader>DD        :<C-U>profile start profile.log<CR>:profile func *<CR>:profile file *<CR>
nnoremap        <leader>DQ        :<C-U>profile pause<CR>:noautocmd quitall!<CR>

nnoremap  <expr><leader>VF        ":<C-U>SplitSensibly " . split(&runtimepath, ",")[0] .  "/ftplugin/" . &filetype . ".vim<CR>"
nnoremap        <leader>VZ        :<C-U>SplitSensibly $ZDOTDIR/.zshrc.local<CR>

nnoremap        <leader>0         :wincmd _<CR>


nnoremap        <leader>`         :<C-U>call <SID>DoCommentTagFormat()<CR>
nnoremap        <leader>.         :<C-U>setlocal autochdir<CR>
nnoremap        <leader>;         :lprevious<CR>
nnoremap        <leader>'         :lnext<CR>
nnoremap        <leader>[         :cprevious<CR>
nnoremap        <leader>]         :cnext<CR>
nnoremap        <leader>{         :cpfile<CR>
nnoremap        <leader>}         :cnfile<CR>
nnoremap        <leader>-         :previous<CR>
nnoremap        <leader>=         :next<CR>
nnoremap        <leader>_         :tabprevious<CR>
nnoremap        <leader>+         :tabnext<CR>
nnoremap        <leader><BS>      :earlier 1f<CR>
nnoremap        <leader>\         :later 1f<CR>
nnoremap        <leader>/         :<C-U>Denite -no-empty grep:.<CR>


nnoremap        <leader><tab>     <C-^>


vnoremap        <leader>d         :Linediff<CR>
vmap            <leader>m         <Plug>(quickhl-manual-this)
vnoremap        <leader>p         "*p
vnoremap        <leader>y         "*y


" ==============
" : Completion :
" ==============

" insert mode completion
set completeopt=menuone,noinsert,noselect,preview

if exists('&pumblend')
    set pumblend=5                          " slightly transparent pum window
endif

set suffixes+=.backup,.hbm,.ini             " lower priority when completing

set wildmode=longest:full,full
if exists('&wildignorecase')
    " TODO: Really I want wildsmartcase (which doesn't exist), but I
    "       don't want to hit longest: if my match was because of case
    "       insensitivity.
    set wildignorecase                      " ignore case in completions
endif

set wildignore+=*.db,*.o,*.obj
set wildignore+=*.swp,*.bak,*.lock
set wildignore+=*.git,*.hg,*.svn
set wildignore+=MANIFEST,*.pyc,**/_trial_temp*/**,*.egg-info/**,*.egg/**,**/build/**,**/htmlcov/**,**/dist/**,**/_build/**,**/.tox/**,**/.testrepository/**
set wildignore+=**/.vim-flavor/**
set wildignore+=*DS_Store*
set wildignore+=version.txt
set wildignore+=**/tmp/**
set wildignore+=*.png,*.jpg,*.gif,*.svg
set wildignore+=*.app,*.dmg,*.pdf,*.so
set wildignore+=**/.gems/**,**/.chef/checksums/**

if filereadable("/usr/share/dict/words")
    set dictionary+=/usr/share/dict/words
endif

" ===========
" : Folding :
" ===========

set foldmethod=indent
set foldlevel=99

" ==========
" : Guides :
" ==========

set cursorline                         " highlight current line

set showmatch                          " show matching brackets for a moment
set matchpairs+=<:>
set matchtime=5                        " show for how long (*tenths* of second)

" show a line at column 79
if exists("&colorcolumn")
    set colorcolumn=+1
endif

" ===========
" : History :
" ===========

set backup
set backupdir=$XDG_CACHE_HOME/nvim/backups,~/tmp,/tmp

if exists("&undofile")
    set undofile
endif

" =============
" : Interface :
" =============

let g:preferred_colorscheme = 'onedark'

if has('gui_running') || &t_Co > 8
    set termguicolors
    execute 'silent colorscheme ' . g:preferred_colorscheme
else
    colorscheme desert
endif

set confirm                            " show confirm dialog instead of warn
set shortmess+=actI                    " show shorter messages
set title                              " change window title to filename

set equalalways                        " hopefully fix how often :sp's mess up
set splitbelow                         " new :sp go on bottom
set splitright                         " new :vsp go on right

set winminheight=0                     " allow totally minimizing a window

set timeoutlen=500                     " shorten the amount of time to wait

set showtabline=1

if exists('+winblend')
    set winblend=20                    " make floating windows transparentish
endif

if has('multi_byte') || has('gui_running')
    set listchars=tab:▸\ ,eol:¬,trail:·,extends:→,precedes:←
else
    set listchars=tab:>-,eol:$,trail:.,extends:>,precedes:<
endif

if has('mouse')
  set mouse=v                          " ugh no mouse while typing, just visual
  set mousemodel=popup
endif

" ============
" : Movement :
" ============

set nostartofline                      " never jump back to start of line

set scrolloff=2                        " keep lines above and below cursor
set sidescrolloff=2                    " same for horizontal

set virtualedit=block

" ==========
" : Search :
" ==========

set ignorecase
set smartcase                          " case-sensitive if upper in search term
set tagcase=followscs

if exists('+inccommand')
    set inccommand=nosplit
endif

if executable("rg")                        " RIP
    set grepprg=rg\ --hidden\ --vimgrep\ --no-heading\ --smart-case\ $*
    set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif filereadable("/usr/local/bin/grep") " or if there's a newer grep...
    set grepprg=/usr/local/bin/grep
endif

" ==============
" : Formatting :
" ==============

if executable("par")
    set formatprg=par
endif

" ============
" : Spelling :
" ============

set spellfile=~/.vim/spellfile.add

" ==============
" : Whitespace :
" ==============

set expandtab               " insert space instead of tab
set shiftround              " rounds indent to a multiple of shiftwidth
set shiftwidth=4            " makes # of spaces = 4 for new tab
set softtabstop=4           " makes the spaces feel like tab
set tabstop=8               " makes # of spaces = 8 for preexisting tab

" ===================
" : Plugin Settings :
" ===================

let g:python_host_prog = expand('~/.local/share/virtualenvs/neovim/bin/python')
let g:python3_host_prog = expand('~/.local/share/virtualenvs/neovim3/bin/python3')

let g:is_posix = 1

let g:tex_flavor='latex'

let g:endwise_no_mappings = v:true
let g:exchange_no_mappings = '1'

let g:vimwiki_key_mappings = {'all_maps': 0}
let g:vimwiki_list = [
    \ {
    \    'path': expand("$XDG_DATA_HOME/nvim/"),
    \    'index': 'global',
    \ }]

let g:SignatureMap = {
      \ 'Leader'             :  "M",
      \ 'PlaceNextMark'      :  "M,",
      \ 'PurgeMarks'         :  "M<Space>",
      \ 'PurgeMarkers'       :  "M<BS>",
      \ 'GotoNextLineAlpha'  :  "",
      \ 'GotoPrevLineAlpha'  :  "",
      \ 'GotoNextSpotAlpha'  :  "",
      \ 'GotoPrevSpotAlpha'  :  "",
      \ 'GotoNextLineByPos'  :  "",
      \ 'GotoPrevLineByPos'  :  "",
      \ 'GotoNextSpotByPos'  :  "",
      \ 'GotoPrevSpotByPos'  :  "",
      \ 'GotoNextMarker'     :  "]-",
      \ 'GotoPrevMarker'     :  "[-",
      \ 'GotoNextMarkerAny'  :  "]=",
      \ 'GotoPrevMarkerAny'  :  "[=",
      \ }

let g:undotree_TreeNodeShape = '✷'

" more stupid things with default mappings
let g:signify_mapping_next_hunk = '<nop>'
let g:signify_mapping_prev_hunk = '<nop>'
let g:signify_mapping_toggle_highlight = '<nop>'
let g:signify_mapping_toggle = '<nop>'

let g:signify_update_on_bufenter = 0
let g:signify_vcs_list = ['git', 'hg']

" ============
" : Autocmds :
" ============

if has("eval")
    " diffthis with some sugar
    function! s:DiffTheseCommand()
        if &diff
            diffoff!
        else
            diffthis

            let window_count = tabpagewinnr(tabpagenr(), '$')
            if window_count == 2
                wincmd w
                diffthis
                wincmd w
            endif
        endif
    endfunction

    command! DiffThese call <SID>DiffTheseCommand()

    " Split a window vertically if it would have at least 79 chars plus a bit
    " of padding, otherwise split it horizontally
    function! s:SplitSensiblyCommand(qargs)
        let padding = 5  " columns

        for window_number in range(1, winnr('$'))
            let buffer_number = winbufnr(window_number)
            let has_no_name = bufname(buffer_number) == ''
            if has_no_name && getbufline(buffer_number, 1, '$') == ['']
                if a:qargs != ''
                    execute window_number . 'wincmd w'
                    execute 'edit ' . a:qargs
                endif

                return
            endif
        endfor

        if winwidth(0) >= (79 + padding) * 2
            execute 'vsplit ' . a:qargs
            wincmd L
        else
            execute 'split ' . a:qargs
        endif
    endfunction

    function! SplitSensibly(path)
        call <SID>SplitSensiblyCommand(a:path)
    endfunction

    command! -nargs=* -complete=file SplitSensibly call <SID>SplitSensiblyCommand('<args>')
    command! -nargs=* -complete=file Ss call <SID>SplitSensiblyCommand('<args>')
    command! -nargs=* -complete=file SS call <SID>SplitSensiblyCommand('<args>')

    " If we're in a wide window, enable line numbers.
    function! <SID>WindowWidth()
        if winwidth(0) > 90
            if exists("&relativenumber")
                setlocal number
                setlocal relativenumber
            elseif exists("&number")
                setlocal number
            endif
        else
            if exists("&relativenumber")
                setlocal nonumber
                setlocal norelativenumber
            elseif exists("&number")
                setlocal nonumber
            endif
        endif
    endfunction

    function! <SID>ToggleNumber()
        setlocal invnumber
        if exists("&relativenumber")
            setlocal invrelativenumber
        endif
    endfunction

    " Expand the active window
    function! <SID>ToggleExpando()
        if !exists("s:expando_enabled")
            let s:expando_enabled = 0
            return <SID>ToggleExpando()
        else
            augroup expando
                autocmd!
                if !s:expando_enabled
                    autocmd WinEnter * :45wincmd >
                    let s:expando_enabled = 1
                    30wincmd >
                else
                    let s:expando_enabled = 0
                    wincmd =
                endif
            augroup END
        endif
    endfunction

    " Format tagged comment blocks based on the post-tag indentation
    let b:comment_tags = ['TODO', 'XXX', 'FIXME']
    function! CommentTagFormat()
        let line_number = v:lnum
        let first_line = getline(line_number)
        let comment_leader = split(&commentstring, '%s')[0]
        let comment = '^\s*' . comment_leader . '\s*'

        for pattern in map(copy(b:comment_tags), 'comment . v:val . ":\\?\\s*"')
            if first_line =~ pattern
                let indent = len(matchstr(first_line, pattern)) - len(comment_leader)
                let second_line = getline(line_number + 1)
                call setline(line_number + 1, substitute(second_line, comment, comment_leader . repeat(' ', indent), ''))
                break
            endif
        endfor
        return 1
    endfunction

    function! <SID>DoCommentTagFormat()
        setlocal formatoptions+=2
        setlocal formatexpr=CommentTagFormat()
    endfunction

    " Edit file under cursor (not matching :help 'isfname) (:help gf)
    " Deliberately left off terminating <cr> if filename can't be found
    " to allow user to modify before execution. (:help cWORD)
    function! EditFileWORD()
        let file = expand('<cWORD>')
        if findfile(file, &path) != ''
            let file .= "\<cr>"
        endif
        return ":SplitSensibly " . file
    endfunction

    function! <SID>CR()
        if &filetype == 'qf'
            return "\<CR>"
        elseif &filetype == 'help'
            return "\<C-]>"
        elseif &filetype == 'vimwiki'
            return ":VimwikiFollowLink\<CR>"
        else
            return ":\<C-U>SplitSensibly\<CR>:VimwikiIndex\<CR>"
        endif
    endfunction
    nnoremap <expr> <CR> <SID>CR()

    if has("autocmd")
        augroup misc
            autocmd!

            " Keep splits equal on resize
            autocmd VimResized * :wincmd =

            " Automagic line numbers
            autocmd BufEnter * :call <SID>WindowWidth()

            " Jump to the last known cursor position if it's valid (from the docs)
            autocmd BufReadPost *
                \   if line("'\"") > 0 && line("'\"") <= line("$") && &ft !~# 'commit'
                \ |   execute "normal! g`\""
                \ | endif

        augroup END

    " =====================
    " : FileType Specific :
    " =====================

        augroup filetypes
            autocmd!
            autocmd BufNewFile,BufRead Gemfile setlocal filetype=ruby
            autocmd BufNewFile,BufRead *.jinja2,*.j2 setlocal filetype=jinja
            autocmd BufNewFile,BufRead *.mako,*.mak setlocal filetype=html
            autocmd BufNewFile,BufRead *.tac setlocal filetype=python

            autocmd BufReadCmd *.egg,*.whl call zip#Browse(expand("<amatch>"))

            autocmd BufWritePost $MYVIMRC source $MYVIMRC

            " Auto-close fugitive buffers
            autocmd BufReadPost fugitive://* set bufhidden=delete
        augroup END

        augroup formatstupidity
            " ftplugins are stupid and try to mess with formatoptions
            autocmd!
            autocmd BufNewFile,BufRead * setlocal formatoptions-=ro
            autocmd BufNewFile,BufRead * silent! setlocal formatoptions+=jln
        augroup END
    endif

    " ======================
    " : Neovim UI Specific :
    " ======================

    if exists('##UIEnter')
        function! OnUIEnter(channel)
            let l:ui = nvim_get_chan_info(a:channel)
            if has_key(l:ui, 'client') &&
            \ has_key(l:ui.client, "name") &&
            \ l:ui.client.name == "Firenvim"
                source $XDG_CONFIG_HOME/nvim/firen.vim
            endif
        endfunction

        autocmd UIEnter * call OnUIEnter(deepcopy(v:event.chan))
    endif
endif

if has('nvim-0.5')
    lua require('config')
endif
