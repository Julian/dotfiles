set nocompatible                       " turn off vi compatible, should be first

let mapleader = "\<space>"
let maplocalleader = ","

" ===========
" : Plugins :
" ===========

let s:load_dynamic_plugins=$VIM_LOAD_DYNAMIC_PLUGINS != "false"

function! <SID>Develop(bundle)
    let bundle_directory = $DEVELOPMENT . '/' . a:bundle
    if isdirectory(bundle_directory)
        let &runtimepath .= ',' . bundle_directory
    else
        execute "Plug 'Julian/" . a:bundle . "'"
    endif
endfunction
command! -nargs=1 Develop call <SID>Develop('<args>')

if has('vim_starting')
    source ~/.vim/bundle/vim-plug/plug.vim
endif
call plug#begin(expand('~/.vim/bundle/'))

" --- Themes ---

Plug      'chriskempson/tomorrow-theme',       {'rtp' : 'vim/'}
Plug      'sickill/vim-monokai'
Plug      'w0ng/vim-hybrid'

" --- Additional Filetype Support ---

Plug      'sheerun/vim-polyglot'

Plug      'guns/vim-clojure-highlight',                 {'for': 'clojure'}
Plug      'guns/vim-sexp',                              {'for': 'clojure'}
Plug      'tpope/vim-fireplace',                        {'for': 'clojure'}
Plug      'tpope/vim-leiningen',                        {'for': 'clojure'}
Plug      'tpope/vim-sexp-mappings-for-regular-people', {'for': 'clojure'}

Plug      'thoughtbot/vim-rspec',              {'for': 'ruby'}
Plug      'tpope/vim-bundler',                 {'for': 'ruby'}
Plug      'tpope/vim-rails',                   {'for': 'ruby'}

" --- Plugins ---

Plug      'ajh17/VimCompletesMe'
Plug      'alfredodeza/coveragepy.vim',        {'for': 'python'}
Plug      'AndrewRadev/linediff.vim',          {'on': 'Linediff'}
Plug      'AndrewRadev/splitjoin.vim'
Plug      'AndrewRadev/switch.vim'
Plug      'b4winckler/vim-angry'
Plug      'bling/vim-airline'
Plug      'bruno-/vim-man'
Plug      'bruno-/vim-vertical-move'
Plug      'dahu/vim-fanfingtastic'
Plug      'godlygeek/tabular',                 {'on': 'Tabularize'}
Plug      'kana/vim-vspec'
Plug      'kana/vim-submode'
Plug      'kien/rainbow_parentheses.vim'
Plug      'kshenoy/vim-signature'
Plug      'jaxbot/github-issues.vim'
Plug      'jmcantrell/vim-diffchanges',        {'on': 'DiffChangesDiffToggle'}
Plug      'majutsushi/tagbar'
Plug      'mhinz/vim-signify'
Plug      'mbbill/undotree'
Plug      'nathanaelkane/vim-indent-guides',   {'on': 'IndentGuidesToggle'}
Plug      'scrooloose/syntastic',              {'on': 'SyntasticCheck'}
Plug      't9md/vim-quickhl'
Plug      'tommcdo/vim-exchange'
Plug      'tomtom/tcomment_vim'
Plug      'tpope/vim-abolish'
Plug      'tpope/vim-dispatch'
Plug      'tpope/vim-endwise'
Plug      'tpope/vim-fugitive'
Plug      'tpope/vim-obsession',               {'on': 'Obsession'}
Plug      'tpope/vim-repeat'
Plug      'tpope/vim-surround'
Plug      'Valloric/MatchTagAlways',           {'for': ['html', 'xhtml', 'xml', 'jinja']}
Plug      'Valodim/vim-zsh-completion'

Plug      'kana/vim-textobj-indent'
Plug      'Julian/vim-textobj-python',         {'for': 'python'}
Plug      'kana/vim-textobj-syntax'
Plug      'kana/vim-textobj-user'

Plug      'Shougo/neomru.vim'
Plug      'Shougo/unite.vim'            |      Plug 'Shougo/vimproc'
Plug      'Shougo/unite-outline'
Plug      'tsukkee/unite-tag'

Develop         vim-runt
Develop         vim-textobj-assignment
Develop         vim-textobj-brace
Develop         vim-textobj-variable-segment

if executable("tmux")
    Plug  'tpope/vim-tbone'
    Plug  'wellle/tmux-complete.vim'
    let g:tmuxcomplete#trigger = ''
endif

if s:load_dynamic_plugins
    Plug 'davidhalter/jedi-vim'
endif

call plug#end()

" =========
" : Basic :
" =========

if has('autocmd')
  filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

if has('vim_starting')
    set encoding=utf8
endif
set autoread                           " automatically reload unmodified bufs
set gdefault
set hidden
set lazyredraw                         " no redraw during macros (much faster)
set linebreak
set report=0                           " :cmd always shows changed line count
set textwidth=79

set nowrap
let &showbreak='↪   '

set fillchars=diff:·

set pastetoggle=<F2>                   " use f2 to toggle paste mode

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
endif

" this one is reserved unfortunately, but for encryption just use vim -xn
cnoreabbrev X x

" testing mappings
nnoremap      <expr><CR>      ":w<CR>:Dispatch "      . (empty(get(t:, 'runt_last_command', '')) ? runt#file(expand("%")) : t:runt_last_command)                .  "<CR>"
nnoremap      <expr>d<CR>     ":SplitSensibly "       . runt#find_test_file_for(expand("%"))                                                                    .  "<CR>"
nnoremap      <expr>dc        ":w<CR>:Dispatch "      . (empty(get(t:, 'runt_last_command', '')) ? runt#class(expand("%"), getpos(".")) : t:runt_last_command)  .  "<CR>"
nnoremap      <expr>dm        ":w<CR>:Dispatch "      . (empty(get(t:, 'runt_last_command', '')) ? runt#method(expand("%"), getpos(".")) : t:runt_last_command) .  "<CR>"
nnoremap            dx         :w<CR>:Dispatch          tox                                                                                                         <CR>
nnoremap            dK         :call                    runt#follow()                                                                                               <CR>
nnoremap      <expr>dS        ":w<CR>:Dispatch "            . (empty(get(t:, 'runt_last_command', '')) ? runt#suite(expand("%")) : t:runt_last_command)         .  "<CR>"

" Put exchange and splitjoin on s, use cl if you want that, but I rarely do.
map s <Plug>(Exchange)

let g:splitjoin_split_mapping = ''
let g:splitjoin_join_mapping = ''
nmap s<CR> :SplitjoinSplit<CR>
nmap ss :SplitjoinJoin<CR>

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

nnoremap <silent> <C-L> :nohlsearch<CR>:diffupdate<CR>:syntax sync fromstart<CR>:XchangeClear<CR><C-L>

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

"       '<F1>' is set to help
"       '<F2>' is set to pastetoggle
let s:all_modes_mappings = {
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

nnoremap        <leader><leader>  :Unite buffer file file_mru tag<CR>


nnoremap        <leader>b         o<C-R>"<Esc>
nnoremap        <leader>d         :<C-U>Unite -no-split -buffer-name=files file_rec/async<CR>
nnoremap        <leader>e         :<C-U>SplitSensibly<CR>:Unite -no-split file_rec/async:
nnoremap        <leader>f         :<C-U>Unite -no-split -buffer-name=buffers buffer_tab<CR>
nnoremap        <leader>h         :<C-U>Unite -no-split -buffer-name=tags tag<CR>
nnoremap        <leader>j         :<C-U>Unite -no-split -buffer-name=test_tags -input=test tag<CR>
nnoremap        <leader>k         :<C-U>Unite -no-split -buffer-name=tests -input=test/test_ file_rec/async<CR>
nnoremap        <leader>l         :<C-U>Unite -no-split -buffer-name=lines line<CR>
nmap            <leader>m         <Plug>(quickhl-manual-this)
nnoremap        <leader>n         <C-F>n
nnoremap  <expr><leader>o         EditFileWORD()
nnoremap        <leader>p         "*p
nnoremap        <leader>r         :<C-u>Unite -no-split -buffer-name=mru file_mru<CR>
nnoremap        <leader>s         :<C-U>Switch<CR>

nnoremap        <leader>ta        :<C-U>TagbarToggle<CR>
nnoremap        <leader>tc        :<C-U>DiffChangesDiffToggle<CR>
nnoremap        <leader>td        :<C-U>DiffThese<CR>
nnoremap        <leader>te        :<C-U>call <SID>ToggleExpando()<CR>
nnoremap        <leader>ti        :<C-U>IndentGuidesToggle<CR>
nnoremap        <leader>tl        :<C-U>set list!<CR>
nnoremap        <leader>tp        :<C-U>set formatoptions-=c<CR>:set spell<CR>
nnoremap        <leader>tq        :<C-U>call <SID>ToggleQuickfix()<CR>
nnoremap        <leader>ts        :<C-U>set spell!<CR>
nnoremap        <leader>tu        :<C-U>UndotreeToggle<CR>
nnoremap        <leader>tw        :<C-U>set wrap!<CR>

nnoremap        <leader>u         :<C-U>set cpoptions+=u<CR>u:w<CR>:set cpoptions-=u<CR>
nnoremap        <leader>v         :<C-U>SplitSensibly $MYVIMRC<CR>
nnoremap        <leader>y         "*y

nnoremap        <leader>gb         :<C-U>Gblame<CR>
nnoremap        <leader>gc         :<C-U>Gcommit<CR>
nnoremap        <leader>gd         :<C-U>Gdiff<CR>
nnoremap        <leader>ge         :<C-U>Gedit<CR>
nnoremap        <leader>gr         :<C-U>Gread<CR>
nnoremap        <leader>gs         :<C-U>Gstatus<CR>
nnoremap        <leader>gw         :<C-U>Gwrite<CR>

nnoremap        <leader>B         o<C-R>*<Esc>
nnoremap  <expr><leader>C         ":<C-U>SplitSensibly<CR>:Unite -no-split -buffer-name=config -input=. file:$HOME file_rec/async:" . $XDG_CONFIG_HOME . "<CR>"
nmap            <leader>M         <Plug>(quickhl-manual-reset)
nnoremap        <leader>N         <C-F>N
nnoremap        <leader>P         "*P
nnoremap        <leader>S         :<C-U>%s/\s\+$//<cr>:let @/=''<CR>
nnoremap        <leader>U         :<C-U>PlugUpdate<CR>
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
nnoremap        <leader><BS>      :earlier 1f<CR>
nnoremap        <leader>\         :later 1f<CR>
nnoremap        <leader>/         :<C-U>Unite -no-split -buffer-name=grep grep:.<CR>


nnoremap        <leader><tab>     <C-^>


vnoremap        <leader>d         :Linediff<CR>
vmap            <leader>m         <Plug>(quickhl-manual-this)
vnoremap        <leader>p         "*p
vnoremap        <leader>y         "*y


" ==============
" : Completion :
" ==============

" insert mode completion
set completeopt=menuone,longest,preview     " follow type in autocomplete
set pumheight=6                             " Keep a small completion window

set showcmd                                 " display incomplete commands

set suffixes+=.backup,.hbm,.ini             " lower priority when completing

set wildmenu                                " file completion helper window
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
set wildignore+=*.png,*.jpg,*.gif
set wildignore+=*.app,*.dmg,*.pdf,*.so
set wildignore+=**/.gems/**,**/.chef/checksums/**

set complete-=i                             " this is slow apparently.

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

set cursorline                         " hilight current line

set showmatch                          " show matching brackets for a moment
set matchpairs+=<:>
set matchtime=5                        " show for how long (*tenths* of second)

" show a line at column 79
if exists("&colorcolumn")
    highlight ColorColumn guibg=#2d2d2d
    set colorcolumn=+1
endif

" ===========
" : History :
" ===========

set directory=$XDG_CACHE_HOME/vim/swap//,~/tmp/vim//,~/tmp//,/var/tmp//,/tmp//
                                                    " swap files
set history=10000                                   " command line history
if has('nvim')
    set shada='50,s100,n$XDG_CACHE_HOME/nvim/shada  " 50 marks, unhuge register
else
    set viminfo='50,s100,n$XDG_CACHE_HOME/vim/info  " 50 marks, unhuge register
endif

set backup
set backupdir=$XDG_CACHE_HOME/vim/backups,~/tmp,/tmp

if exists("&undofile")
    set undofile
    set undodir=$XDG_CACHE_HOME/vim/undo,$HOME/tmp,/tmp
endif

set undolevels=500                                  " more undo


" =============
" : Interface :
" =============

set background=dark                    " make sure this is before colorschemes

let g:preferred_colorscheme = 'hybrid'

if has('gui_running') || &t_Co > 8
    execute 'silent colorscheme ' . g:preferred_colorscheme
else
    colorscheme desert
endif

set laststatus=2                       " always show status line

if &statusline!~?'airline\|powerline' && (!exists("g:powerline_loaded") || !g:powerline_loaded)
    set statusline=[%l,%v\ %P%M]\ %f\ %r%h%w\ (%{&ff})
    if exists("g:loaded_fugitive")
        set statusline+=\ %{fugitive#statusline()}
    endif
endif

set confirm                            " show confirm dialog instead of warn
set display+=lastline                  " show as much of lastline possible
set shortmess+=atI                     " show shorter messages
set title                              " change window title to filename

set equalalways                        " hopefully fix how often :sp's mess up
set splitbelow                         " new :sp go on bottom
set splitright                         " new :vsp go on right

set winminheight=0                     " allow totally minimizing a window

set timeoutlen=500                     " shorten the amount of time to wait

" no bells or blinking
set noerrorbells
set novisualbell
set vb t_vb=

" Change the cursor to an underline in insert mode
if &term =~ 'xterm\|screen'
    set t_SI=[4\ q
    set t_EI=[2\ q
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

set backspace=indent,eol,start         " backspacing over everything in insert
set nostartofline                      " never jump back to start of line
set ruler                              " show the cursor position all the time

set scrolloff=2                        " keep lines above and below cursor
set sidescrolloff=2                    " same for horizontal

set virtualedit=block

" ==========
" : Search :
" ==========

set ignorecase
set smartcase                          " case-sensitive if upper in search term
set incsearch                          " do incremental searching
set hlsearch                           " hilight searches

if executable("rg")                        " RIP
    set grepprg=rg\ --vimgrep\ --no-heading\ $*
    set grepformat=%f:%l:%c:%m,%f:%l:%m
elseif executable("ag")                    " if the silver searcher's around...
    set grepprg=ag\ --vimgrep\ $*
    set grepformat=%f:%l:%c:%m
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

set autoindent

set expandtab               " insert space instead of tab
set shiftround              " rounds indent to a multiple of shiftwidth
set shiftwidth=4            " makes # of spaces = 4 for new tab
set softtabstop=4           " makes the spaces feel like tab
set tabstop=8               " makes # of spaces = 8 for preexisitng tab

" ===================
" : Plugin Settings :
" ===================

let g:is_posix = 1

let g:tex_flavor='latex'

let g:exchange_no_mappings = '1'

if filereadable('/usr/local/bin/ctags')
    let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
else
    let g:tagbar_ctags_bin = '/usr/bin/ctags'
endif

" signature
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

let g:tcommentTextObjectInlineComment = 'ix'
let g:tcommentMapLeader1 = ''
let g:tcommentMapLeader2 = ''

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

    " Toggle the quick fix window
    function! <SID>ToggleQuickfix()
        " This is broken if someone decides to do copen or cclose without using
        " the mapping, but just look at the ugliness required to do it properly
        " http://vim.wikia.com/wiki/Toggle_to_open_or_close_the_quickfix_window
        if !exists("s:quickfix_open")
            let s:quickfix_open = 0
            return <SID>ToggleQuickfix()
        else
            if s:quickfix_open
                :cclose
                let s:quickfix_open = 0
            else
                :copen
                let s:quickfix_open = 1
            endif
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

    function! GdiffAll(...)
        if a:0 > 0
            let branch = a:1
        else
            let branch = 'develop'
        endif

        execute 'Git! diff --name-only ' . l:branch
        global/./execute 'tabedit ' . getline('.') . '| Gdiff ' l:branch . ' | tabprevious'
        close
    endfunction

    if has("autocmd")
        augroup misc
            autocmd!

            " Keep splits equal on resize
            autocmd VimResized * :wincmd =

            " Automagic line numbers
            autocmd BufEnter * :call <SID>WindowWidth()

            " Always do a full syntax refresh
            autocmd BufEnter * syntax sync fromstart

            " For help files, make <Return> behave like <C-]> (jump to tag)
            autocmd FileType help nmap <buffer> <Return> <C-]>

            " Jump to the last known cursor position if it's valid (from the docs)
            autocmd BufReadPost *
                \ if line("'\"") > 0 && line("'\"") <= line("$")                  |
                \   execute "normal! g`\""                                             |
                \ endif

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

            autocmd BufReadCmd *.egg call zip#Browse(expand("<amatch>"))

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
endif

" ============================
" : Local / Project Specific :
" ============================

set secure
set exrc
