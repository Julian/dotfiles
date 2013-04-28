set nocompatible                       " turn off vi compatible, should be first

let mapleader = "\<space>"

" ==========
" : Vundle :
" ==========

filetype off
set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()

" Let Vundle manage Vundle (required!).
Bundle 'gmarik/vundle'

" --- Themes ---
Bundle 'altercation/vim-colors-solarized'
Bundle 'chriskempson/tomorrow-theme', {'rtp': 'vim/'}
Bundle 'noahfrederick/Hemisu'
Bundle 'sickill/vim-monokai'

" --- Temporary ---
Bundle 'dahu/VimRegexTutor'

" --- Additional Filetype Support ---
Bundle 'hail2u/vim-css3-syntax'
Bundle 'kchmck/vim-coffee-script'
Bundle 'kien/rainbow_parentheses.vim'
Bundle 'othree/html5.vim'
Bundle 'sontek/rope-vim'
Bundle 'tpope/vim-fireplace'
Bundle 'tpope/vim-git'
Bundle 'vim-ruby/vim-ruby'

Bundle 'git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex'

" --- Plugins ---

Bundle 'alfredodeza/coveragepy.vim'
Bundle 'alfredodeza/pytest.vim'
Bundle 'b4winckler/vim-angry'
Bundle 'ervandew/supertab'
Bundle 'JazzCore/neocomplcache-ultisnips'
Bundle 'Lokaltog/vim-easymotion'
Bundle 'Lokaltog/vim-powerline'
Bundle 'majutsushi/tagbar'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'scrooloose/syntastic'
Bundle 'Shougo/neocomplcache'
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

if has("python")
    " Bundle 'davidhalter/jedi-vim'
    Bundle 'SirVer/ultisnips'
endif

if isdirectory(expand("~/Development/vim-runt"))
    set runtimepath+=~/Development/vim-runt
else
    Bundle 'Julian/vim-runt'
endif

if has("ruby")
    Bundle 'git://git.wincent.com/command-t.git'

    nmap          <leader>f         :CommandTBuffer<CR>
    nmap          <leader>g         :CommandT<CR>
else
    Bundle 'kien/ctrlp.vim'

    nmap          <leader>f         :CtrlPBuffer<CR>
    nmap          <leader>g         :CtrlP<CR>
endif

" --- Disabled / Saved ---
" Bundle 'KevinGoodsell/vim-csexact'
" Bundle 'skammer/vim-css-color'
" Bundle 'sjl/gundo.vim'

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
set nowrap
set report=0                           " :cmd always shows changed line count
set textwidth=79

set pastetoggle=<F2>                   " use f2 to toggle paste mode

set cryptmethod=blowfish               " use blowfish for encryption

set tags=./tags;$HOME                  " look up until $HOME for tags

" ============
" : Bindings :
" ============

" quick fingers / for encryption use vim -xn
cnoreabbrev Q q
cnoreabbrev Sp sp
cnoreabbrev Vsp vsp
cnoreabbrev WQ wq
cnoreabbrev Wq wq
cnoreabbrev W w
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
" sunmap ' sunmap ` sunmap g' sunmap g`

" Preserve flags for &, and add it in visual mode.
nnoremap & :&&<CR>
xnoremap & :&&<CR>

nnoremap <silent> <C-L> :nohlsearch<CR><C-L>

" make undo less drastic + prevent accidental irreversible undo
" not sure why cr one is not working
inoremap <BS> <BS><C-G>u
" inoremap <CR> <C-G>u<CR>
inoremap <DEL> <DEL><C-G>u
inoremap <C-U> <C-G>u<C-U>
inoremap <C-W> <C-G>u<C-W>

" unbind cursor keys
for prefix in ['i', 'n', 'v']
  for key in ['<Up>', '<Down>', '<Left>', '<Right>']
    exe prefix . "noremap " . key . " <Nop>"
  endfor
endfor

" Toggle how long lines are displayed
nmap          <F11>             :set wrap!<CR>
" fix syntax highlighting errors
noremap       <F12>             <Esc>:syntax sync fromstart<CR>
inoremap      <F12>             <C-o>:syntax sync fromstart<CR>

" Leader mappings
" ---------------
"
" Here are explanations for non-self-explanatory ones:
"
"   b : paste last deletion on its own line despite it being charwise
"   d : minimize a window
"   B : paste system clipboard on its own line despite it not having a newline
"   J : reverse line join (line squash)
"   S : remove trailing whitespace
"   . : set the working directory in the local window

nmap          <leader>a         :TagbarToggle<CR>
nmap          <leader>b         o<C-R>"<Esc>
nmap          <leader>c         :SplitByWidth<CR>:CommandT $XDG_CONFIG_HOME<CR>
nmap          <leader>d         <C-W>0_
nmap          <leader>e         :SplitByWidth<CR>:CommandT 
"             <leader>f         Set above to CommandTBuffer or CtrlPBuffer
"             <leader>g         Set above to CommandT or CtrlP
nmap          <leader>k         :call <SID>ToggleExpando()<CR>
nmap          <leader>l         :set list!<CR>
nmap          <leader>p         "*p
nmap          <leader>q         :call <SID>ToggleQuickfix()<CR>
nmap          <leader>s         :set spell!<CR>
nmap          <leader>t         :topleft split TODO<CR><C-W>6_
nmap          <leader>u         :set cpoptions+=u<CR>u:w<CR>:set cpoptions-=u<CR>
nmap          <leader>v         :SplitByWidth $MYVIMRC<CR>
nmap          <leader>y         "*y
nmap          <leader>z         :SplitByWidth $ZDOTDIR/.zshrc<CR>

nmap          <leader>jj        :Dispatch TestRunnerCommand(FindTestFile(expand("%"))))<CR>
nmap          <leader>jl        :ToggleTestLock<CR>
nmap          <leader>jt        :Dispatch! tox<CR>
nmap          <leader>js        :Dispatch! RunTestSuite(expand("%")))<CR>
nmap          <leader>jq        :Copen<CR>
nmap          <leader>j<leader> :Dispatch<CR>


nnoremap      <leader>B         o<C-R>*<Esc>
nnoremap      <leader>J         ddpkJ
nnoremap      <leader>S         :%s/\s\+$//<cr>:let @/=''<CR>

nnoremap      <leader>.         :lcd %:p:h<CR>
nmap          <leader>]         :cnext<CR>
nmap          <leader>[         :cprevious<CR>
nmap          <leader>-         :next<CR>
nmap          <leader>=         :previous<CR>

nmap          <leader><tab>     :b#<CR>

vmap          <leader>y         "*y


" ==============
" : Completion :
" ==============

" insert mode completion
set completeopt=menuone,longest,preview " follow type in autocomplete
set pumheight=6                        " Keep a small completion window

set showcmd                            " display incomplete commands

set wildmenu                           " file completion helper window
set wildmode=longest:full,full
set wildignore+=*.o,*.obj,*.swp,*.bak,*.git,*.pyc,**/_trial_temp/**,*.egg-info/**,*.egg/**,**/build/**,**/htmlcov/**,**/dist/**,MANIFEST,**/_build/**
set suffixes+=.backup,.ini             " lower priority when completing

set complete-=i                        " this is slow apparently.

if filereadable("/usr/share/dict/words")
    set dictionary+=/usr/share/dict/words
endif


" augroup cursorMove
"     " close preview window automatically when we move around
"     au!
"     autocmd CursorMovedI * if pumvisible() == 0|silent! pclose|endif
"     autocmd InsertLeave * if pumvisible() == 0|silent! pclose|endif
" augroup END

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

set history=1000                       " command line history
set viminfo='50,s100                   " 50 files' marks, non-huge registers

set backup
set backupdir=~/.vim/sessions,~/tmp,/tmp    " put backups and...

if exists("&undofile")
    set undofile
    set undodir=~/.vim/sessions,~/tmp,/tmp  " ... undos
endif

set undolevels=500                     " more undo

set directory=~/.vim/sessions,~/tmp,/tmp    " swap files here instead of .

" =============
" : Interface :
" =============

set background=dark                    " make sure this is before colorschemes

if &t_Co > 8
    set t_Co=256
    colorscheme hemisu
elseif &t_Co == 8
    if $TERM !~# '^linux'
        set t_Co=16
    endif

    colorscheme desert
endif

set laststatus=2                       " always show status line

" doesn't actually do anything since we've got Powerline but kept just in case
set statusline=[%l,%v\ %P%M]\ %f\ %r%h%w\ (%{&ff})\ %{fugitive#statusline()}

set confirm                            " show confirm dialog instead of warn
set display+=lastline                  " show as much of lastline possible
set listchars=tab:▸\ ,eol:¬
set shortmess+=atI                     " show shorter messages
set title                              " change window title to filename

set equalalways                        " hopefully fix how often :sp's mess up
set splitbelow                         " new :sp go on bottom
set splitright                         " new :vsp go on right

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
    set grepprg=ag\ --column
elseif filereadable("/usr/local/bin/grep") " or if there's a newer grep...
    set grepprg=/usr/local/bin/grep
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

if filereadable('/usr/local/bin/ctags')
    let g:tagbar_ctags_bin = '/usr/local/bin/ctags'
else
    let g:tagbar_ctags_bin = '/usr/bin/ctags'
endif

" Clear the CommandT window with any of these
let g:CommandTCancelMap=['<ESC>', '<C-c>', '<C-[>']

" vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

" neocomplcache
let g:neocomplcache_disabled_sources_list = {'_' : ['dictionary_complete']}
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_smart_case = 1
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_max_list = 10

let g:Powerline_symbols = 'unicode'

" Supertab
let g:SuperTabDefaultCompletionType = "context"  " try to guess completion
let g:SuperTabLongestEnhanced = 1                " enhanced longest complete
let g:SuperTabLongestHighlight = 1               " preselect first result

" Syntastic
let g:syntastic_error_symbol="✖"
let g:syntastic_warning_symbol="✦"

" UltiSnips
let g:UltiSnipsListSnippets = "<C-K>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsDontReverseSearchPath="1"        " appears needed to overwrite

" VimClojure
let g:vimclojure#ParenRainbow = 1

let g:jedi#use_tabs_not_buffers = 0
let g:jedi#goto_command = "<leader>\\"
let g:jedi#get_definition_command = "<leader>`"

augroup rainbowparentheses
    au!
    au VimEnter * RainbowParenthesesToggle
    au Syntax * RainbowParenthesesLoadRound
    au Syntax * RainbowParenthesesLoadSquare
    au Syntax * RainbowParenthesesLoadBraces
augroup END

" ============
" : Autocmds :
" ============

if has("eval")

    function! s:SplitByWidthCommand(qargs)
        let padding = 5  " columns

        if bufname('%') == '' && getline(1, '$') == ['']
            if a:qargs == ''
                return
            endif

            exec 'edit ' . a:qargs
        elseif winwidth(0) >= (79 + padding) * 2
            exec 'vsplit ' . a:qargs
            wincmd L
        else
            exec 'split ' . a:qargs
        endif
    endfunction

    " Split a window vertically if it would have at least 79 chars plus a bit
    " of padding, otherwise split it horizontally
    function! SplitByWidth(path)
        <SID>SplitByWidthCommand(a:path)
    endfun

    command! -nargs=* -complete=file_in_path SplitByWidth call <SID>SplitByWidthCommand('<args>')
    cabbrev Sw SplitByWidth

    " If we're in a wide window, enable line numbers.
    function! <SID>WindowWidth()
        if winwidth(0) > 90
            setlocal foldcolumn=2
            if exists("&relativenumber")
                setlocal relativenumber
            endif
        else
            setlocal foldcolumn=0
            if exists("&relativenumber")
                setlocal norelativenumber
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
                au!
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
endif

if has("autocmd") && has("eval")

    augroup misc
        au!

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
    au!
    autocmd BufNewFile,BufRead *.j2 setlocal filetype=jinja
    autocmd BufNewFile,BufRead *.mako,*.mak setlocal filetype=html
    autocmd BufNewFile,BufRead *.tac setlocal filetype=python

    " Compile coffeescript on write (requires vim-coffee-script)
    autocmd BufWritePost *.coffee silent CoffeeMake!

    autocmd BufWritePost .vimrc source $MYVIMRC
augroup END

augroup formatstupidity
    " ftplugins are stupid and try to mess with formatoptions
    au!
    autocmd BufNewFile,BufRead * setlocal formatoptions-=ro
    autocmd BufNewFile,BufRead * silent! setlocal formatoptions+=j
augroup END

let g:tex_flavor='latex'
