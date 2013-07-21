set nocompatible                       " turn off vi compatible, should be first

let mapleader = "\<space>"
let maplocalleader = ","

" ==========
" : Vundle :
" ==========

filetype off
set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()

let s:load_dynamic_plugins=$VIM_LOAD_DYNAMIC_PLUGINS != "false"

" Let Vundle manage Vundle (required!).
Bundle 'gmarik/vundle'

" --- Themes ---

Bundle 'altercation/vim-colors-solarized'
Bundle 'chriskempson/tomorrow-theme', {'rtp' : 'vim/'}
Bundle 'noahfrederick/Hemisu'
Bundle 'sickill/vim-monokai'

" --- Additional Filetype Support ---

Bundle 'guns/vim-clojure-static'
Bundle 'hail2u/vim-css3-syntax'
Bundle 'kchmck/vim-coffee-script'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'othree/html5.vim'
Bundle 'tpope/vim-fireplace'
Bundle 'tpope/vim-git'
Bundle 'vim-ruby/vim-ruby'

Bundle 'git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex'

" --- Plugins ---

Bundle 'AndrewRadev/switch.vim'
Bundle 'bling/vim-airline'
Bundle 'alfredodeza/coveragepy.vim'
Bundle 'alfredodeza/pytest.vim'
Bundle 'b4winckler/vim-angry'
Bundle 'dahu/vim-fanfingtastic'
Bundle 'dahu/vimple'
Bundle 'godlygeek/tabular'
Bundle 'jmcantrell/vim-diffchanges'
Bundle 'majutsushi/tagbar'
Bundle 'mhinz/vim-signify'
Bundle 'mbbill/undotree'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'scrooloose/syntastic'
Bundle 'terryma/vim-multiple-cursors'
Bundle 'tomtom/tcomment_vim'
Bundle 'tpope/vim-abolish'
Bundle 'tpope/vim-dispatch'
Bundle 'tpope/vim-endwise'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-obsession'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-rhubarb'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-tbone'

Bundle 'kana/vim-textobj-function'
Bundle 'kana/vim-textobj-indent'
Bundle 'bps/vim-textobj-python'
Bundle 'kana/vim-textobj-user'

Bundle 'Shougo/unite.vim'
Bundle 'Shougo/vimproc'
Bundle 'tsukkee/unite-tag'

if s:load_dynamic_plugins
    Bundle 'Valloric/YouCompleteMe'
endif

if has("python") && s:load_dynamic_plugins
    Bundle 'SirVer/ultisnips'
endif

if isdirectory(expand("~/Development/vim-runt"))
    set runtimepath+=~/Development/vim-runt
else
    Bundle 'Julian/vim-runt'
endif

silent! runtime macros/matchit.vim


" =========
" : Basic :
" =========

if has('autocmd')
  filetype plugin indent on
endif
if has('syntax') && !exists('g:syntax_on')
  syntax enable
endif

set encoding=utf8
set autoread                           " automatically reload unmodified bufs
set gdefault
set hidden
set lazyredraw                         " no redraw during macros (much faster)
set linebreak
set report=0                           " :cmd always shows changed line count
set textwidth=79

set nowrap
set showbreak=↪

set fillchars=diff:·

set pastetoggle=<F2>                   " use f2 to toggle paste mode

silent! set cryptmethod=blowfish       " use blowfish for encryption

set isfname-==                         " remove =, which probably is an assign

set tags=.tags,tags;$HOME          " look up until $HOME for tags

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

" don't use Ex mode, use Q for formatting
map Q gqap

" change Y to act like C, D
map Y y$

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

nnoremap <silent> <C-L> :nohlsearch<CR>:diffupdate<CR><C-L>

" make undo less drastic + prevent accidental irreversible undo
" not sure why cr one is not working
inoremap <BS> <BS><C-G>u
" inoremap <CR> <C-G>u<CR>
inoremap <DEL> <DEL><C-G>u
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" surround doesn't support deleting a function surround for some reason
nmap dsf Bdt(ds)

let s:all_modes_mappings = {
    \   '<F6>'  : ':IndentGuidesToggle<CR>',
    \   '<F7>'  : ':TagbarToggle<CR>',
    \   '<F8>'  : ':make<CR>',
    \   '<F9>'  : ':syntax sync fromstart<CR>',
    \   '<F10>' : ':set list!<CR>',
    \   '<F11>' : ':set wrap!<CR>',
    \   '<F12>' : ':set spell!<CR>',
    \
    \   '<Up>' : '<Nop>',
    \   '<Down>' : '<Nop>',
    \   '<Left>' : '<Nop>',
    \   '<Right>' : '<Nop>'
    \
    \}

for [key, value] in items(s:all_modes_mappings)
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
"   d : minimize a window
"   n : search forward, but not anything currently displayed
"   w : undo/redo toggle
"   B : paste system clipboard on its own line despite it not having a newline
"   N : search backward, but not anything currently displayed
"   S : remove trailing whitespace
"   . : set the working directory in the local window

nnoremap        <leader>b         o<C-R>"<Esc>
nnoremap        <leader>c         :SplitSensibly<CR>:CommandT $XDG_CONFIG_HOME<CR>
nnoremap        <leader>d         :DiffChangesDiffToggle<CR>
nnoremap        <leader>e         :SplitSensibly<CR>:Unite -no-split -start-insert file_rec/async:
nnoremap        <leader>f         :<C-u>Unite -no-split -buffer-name=buffers buffer<CR>
nnoremap        <leader>g         :<C-u>Unite -no-split -buffer-name=files file_rec/async<CR>
nnoremap        <leader>h         :<C-u>Unite -no-split -buffer-name=tags tag<CR>
nnoremap        <leader>k         :call <SID>ToggleExpando()<CR>
nnoremap        <leader>l         :<C-u>Unite -no-split -buffer-name=lines line<CR>
nnoremap        <leader>m         :wincmd _<CR>
nnoremap        <leader>n         <C-F>n
nnoremap        <leader>p         "*p
nnoremap        <leader>q         :<C-u>Unite -no-split -buffer-name=mru file_mru<CR>
nnoremap        <leader>r         :set cpoptions+=u<CR>u:w<CR>:set cpoptions-=u<CR>
nnoremap        <leader>t         :topleft split TODO<CR><C-W>6_
nnoremap        <leader>u         :UndotreeToggle<CR>
nnoremap        <leader>v         :SplitSensibly $MYVIMRC<CR>
nnoremap        <leader>w         :Switch<CR>
nnoremap        <leader>y         "*y
nnoremap        <leader>z         :SplitSensibly $ZDOTDIR/.zshrc<CR>

nnoremap        <leader>jd        :Dispatch! detox<CR>
nnoremap        <leader>jj        :Dispatch TestRunnerCommand(FindTestFile(expand("%"))))<CR>
nnoremap        <leader>jl        :ToggleTestLock<CR>
nnoremap        <leader>jt        :Dispatch! tox<CR>
nnoremap        <leader>js        :Dispatch! RunTestSuite(expand("%")))<CR>
nnoremap        <leader>jq        :Copen<CR>
nnoremap        <leader>j<leader> :Dispatch<CR>


nnoremap        <leader>B         o<C-R>*<Esc>
nnoremap        <leader>N         <C-F>N
nnoremap        <leader>P         "*P
nnoremap        <leader>S         :%s/\s\+$//<cr>:let @/=''<CR>
nnoremap        <leader>U         :BundleInstall!<CR>

nnoremap        <leader>DD        :profile start profile.log<CR>:profile func *<CR>:profile file *<CR>
nnoremap        <leader>DQ        :profile pause<CR>:noautocmd quitall!<CR>

nnoremap        <leader>.         :lcd %:p:h<CR>
nnoremap        <leader>;         :lprevious<CR>
nnoremap        <leader>'         :lnext<CR>
nnoremap        <leader>[         :cprevious<CR>
nnoremap        <leader>]         :cnext<CR>
nnoremap        <leader>{         :cpfile<CR>
nnoremap        <leader>}         :cnfile<CR>
nnoremap        <leader>-         :previous<CR>
nnoremap        <leader>=         :next<CR>
nnoremap        <leader>\         :call <SID>DoCommentTagFormat()<CR>
nnoremap        <leader>/         :Unite -no-split -buffer-name=grep grep:.<CR>

nnoremap        <leader><tab>     :b#<CR>

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
set wildignore+=*.db,*.o,*.obj,*.swp,*.bak,*.git,*.pyc,**/_trial_temp/**,*.egg-info/**,*.egg/**,**/build/**,**/htmlcov/**,**/dist/**,MANIFEST,**/_build/**

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
set matchtime=5                        " show for how long

" show a line at column 79
if exists("&colorcolumn")
    highlight ColorColumn guibg=#2d2d2d
    set colorcolumn=+1
endif

" ===========
" : History :
" ===========

set directory=$XDG_CACHE_HOME/vim/swap,~/tmp,/tmp   " sawp files
set history=10000                                   " command line history
set viminfo='50,s100,n$XDG_CACHE_HOME/vim/info      " 50 marks, unhuge register

set backup
set backupdir=$XDG_CACHE_HOME/vim/backups,~/tmp,/tmp

if exists("&undofile")
    set undofile
    set undodir=$XDG_CACHE_HOME/undo,~/tmp,/tmp
endif

set undolevels=500                                  " more undo


" =============
" : Interface :
" =============

set background=dark                    " make sure this is before colorschemes

if &t_Co > 8
    set t_Co=256
    silent colorscheme hemisu
elseif &t_Co == 8
    if $TERM !~# '^linux'
        set t_Co=16
    endif

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
set listchars=tab:▸\ ,eol:¬
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

if executable("ag")                        " if the silver searcher's around...
    set grepprg=ag\ --column\ --nogroup\ --nocolor\ --smart-case
    set grepformat=%f:%l:%c:%m,%f
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

let g:airline_left_sep = '»'
let g:airline_right_sep = '«'
let g:airline_linecolumn_prefix = '␤ '
let g:airline_fugitive_prefix = '⎇ '

if filereadable('/usr/local/bin/ctags')
    let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
else
    let g:tagbar_ctags_bin = '/usr/bin/ctags'
endif

" Syntastic
let g:syntastic_error_symbol="✖"
let g:syntastic_warning_symbol="✦"

" UltiSnips
let g:UltiSnipsListSnippets = "<C-K>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsDontReverseSearchPath="1"        " appears needed to overwrite

let g:undotree_TreeNodeShape = '✷'

let g:jedi#goto_command = "gd"
let g:jedi#get_definition_command = "<leader>`"
let g:jedi#use_tabs_not_buffers = 0

" more stupid things with default mappings
let g:signify_mapping_next_hunk = ''
let g:signify_mapping_prev_hunk = ''
let g:signify_mapping_toggle_highlight = '<nop>'
let g:signify_mapping_toggle = '<nop>'

" YouCompleteMe
let g:ycm_filetype_blacklist = {
    \ 'unite' : 1,
    \}

" Vimple
nmap <nop> <Plug>VimpleMRU

" ============
" : Autocmds :
" ============

if has("eval")

    " Split a window vertically if it would have at least 79 chars plus a bit
    " of padding, otherwise split it horizontally
    function! s:SplitSensiblyCommand(qargs)
        let padding = 5  " columns

        if bufname('%') == '' && getline(1, '$') == ['']
            if a:qargs == ''
                return
            endif

            execute 'edit ' . a:qargs
        elseif winwidth(0) >= (79 + padding) * 2
            execute 'vsplit ' . a:qargs
            wincmd L
        else
            execute 'split ' . a:qargs
        endif
    endfunction

    function! SplitSensibly(path)
        <SID>SplitSensiblyCommand(a:path)
    endfun

    command! -nargs=* -complete=file SplitSensibly call <SID>SplitSensiblyCommand('<args>')
    command! -nargs=* -complete=file Ss call <SID>SplitSensiblyCommand('<args>')

    " If we're in a wide window, enable line numbers.
    function! <SID>WindowWidth()
        if winwidth(0) > 90
            if exists("&relativenumber")
                setlocal relativenumber
            elseif exists("&number")
                setlocal number
            endif
        else
            if exists("&relativenumber")
                setlocal norelativenumber
            elseif exists("&number")
                setlocal nonumber
            endif
        endif
    endfun

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
    endfun

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
    endfun

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
endif

if has("autocmd") && has("eval")

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
            \   exe "normal g`\""                                             |
            \ endif

    augroup END

endif


" =====================
" : FileType Specific :
" =====================

augroup filetypes
    autocmd!
    autocmd BufNewFile,BufRead *.jinja2,*.j2 setlocal filetype=jinja
    autocmd BufNewFile,BufRead *.mako,*.mak setlocal filetype=html
    autocmd BufNewFile,BufRead *.tac setlocal filetype=python

    " Compile coffeescript on write (requires vim-coffee-script)
    autocmd BufWritePost *.coffee silent CoffeeMake!

    autocmd BufWritePost .vimrc source $MYVIMRC

    " Auto-close fugitive buffers
    autocmd BufReadPost fugitive://* set bufhidden=delete
augroup END

augroup formatstupidity
    " ftplugins are stupid and try to mess with formatoptions
    autocmd!
    autocmd BufNewFile,BufRead * setlocal formatoptions-=ro
    autocmd BufNewFile,BufRead * silent! setlocal formatoptions+=j
augroup END

let g:tex_flavor='latex'
