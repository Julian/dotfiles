set nocompatible                       " turn off vi compatible, should be first

let mapleader = "\<space>"

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
Bundle 'airblade/vim-gitgutter'
Bundle 'alfredodeza/coveragepy.vim'
Bundle 'alfredodeza/pytest.vim'
Bundle 'b4winckler/vim-angry'
Bundle 'dahu/vim-fanfingtastic'
Bundle 'dahu/vimple'
Bundle 'majutsushi/tagbar'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'nathanaelkane/vim-indent-guides'
Bundle 'scrooloose/syntastic'
Bundle 'sjl/gundo.vim'
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

if s:load_dynamic_plugins
    try
        python from powerline.vim import setup as powerline_setup
        python powerline_setup()
        python del powerline_setup
    catch
        Bundle 'Lokaltog/powerline', {'rtp' : 'powerline/bindings/vim'}
    endtry
endif

if has("ruby") && s:load_dynamic_plugins
    Bundle 'git://git.wincent.com/command-t.git'

    nnoremap      <leader>f         :CommandTBuffer<CR>
    nnoremap      <leader>g         :CommandT<CR>
    nnoremap      <leader>h         :CommandTTag<CR>
else
    Bundle 'kien/ctrlp.vim'

    nnoremap      <leader>f         :CtrlPBuffer<CR>
    nnoremap      <leader>g         :CtrlP<CR>
    nnoremap      <leader>h         :CtrlPTag<CR>
endif


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

set fillchars=diff:⣿,vert:│

set pastetoggle=<F2>                   " use f2 to toggle paste mode

set cryptmethod=blowfish               " use blowfish for encryption

set isfname-==                         " remove =, which probably is an assign

set tags=./.tags,./tags;$HOME          " look up until $HOME for tags

" ============
" : Bindings :
" ============

" quick fingers / for encryption use vim -xn
cnoreabbrev E e
cnoreabbrev Q q
cnoreabbrev Qa qa
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
noremap ]' ]`
noremap ]` ]'
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

noremap         <F10>      :set spell!<CR>

" Toggle how long lines are displayed
noremap         <F11>      :set wrap!<CR>

" fix syntax highlighting errors
noremap         <F12>      <Esc>:syntax sync fromstart<CR>
inoremap        <F12>      <C-o>:syntax sync fromstart<CR>

" surround doesn't support deleting a function surround for some reason
nmap dsf Bdiwds)

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

nnoremap        <leader>a         :TagbarToggle<CR>
nnoremap        <leader>b         o<C-R>"<Esc>
nnoremap        <leader>c         :SplitSensibly<CR>:CommandT $XDG_CONFIG_HOME<CR>
nnoremap        <leader>e         :SplitSensibly<CR>:CommandT 
"               <leader>f         Set above to CommandTBuffer or CtrlPBuffer
"               <leader>g         Set above to CommandT or CtrlP
"               <leader>h         Set above to CommandTTags or CtrlPTag
nnoremap        <leader>i         :IndentGuidesToggle<CR>
nnoremap        <leader>k         :call <SID>ToggleExpando()<CR>
nnoremap        <leader>l         :set list!<CR>
nnoremap        <leader>m         :wincmd _<CR>
nnoremap        <leader>n         <C-F>n
nnoremap        <leader>p         "*p
nnoremap        <leader>r         :set cpoptions+=u<CR>u:w<CR>:set cpoptions-=u<CR>
nnoremap        <leader>t         :topleft split TODO<CR><C-W>6_
nnoremap        <leader>u         :GundoToggle<CR>
nnoremap        <leader>v         :SplitSensibly $MYVIMRC<CR>
nnoremap        <leader>w         :Switch<CR>
nnoremap        <leader>y         "*y
nnoremap        <leader>z         :SplitSensibly $ZDOTDIR/.zshrc<CR>

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

nnoremap        <leader>.         :lcd %:p:h<CR>
nnoremap        <leader>;         :lprevious<CR>
nnoremap        <leader>'         :lnext<CR>
nnoremap        <leader>[         :cprevious<CR>
nnoremap        <leader>]         :cnext<CR>
nnoremap        <leader>-         :previous<CR>
nnoremap        <leader>=         :next<CR>
nnoremap        <leader>\         :call <SID>DoCommentTagFormat()<CR>

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

set history=1000                            " command line history
set viminfo='50,s100                        " 50 file marks, non-huge registers

set backup
set backupdir=~/.vim/sessions,~/tmp,/tmp    " put backups and...

if exists("&undofile")
    set undofile
    set undodir=~/.vim/sessions,~/tmp,/tmp  " ... undos
endif

set undolevels=500                          " more undo

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

if &statusline!~"powerline" && (!exists("g:powerline_loaded") || !g:powerline_loaded)
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
let g:CommandTMatchWindowAtTop=1

" Syntastic
let g:syntastic_error_symbol="✖"
let g:syntastic_warning_symbol="✦"

" UltiSnips
let g:UltiSnipsListSnippets = "<C-K>"
let g:UltiSnipsJumpForwardTrigger = "<tab>"
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>"
let g:UltiSnipsDontReverseSearchPath="1"        " appears needed to overwrite

if has("autocmd") && exists("did_UltiSnips_vim")
    function! g:UltiSnips_Complete()
        call UltiSnips_ExpandSnippet()
        if g:ulti_expand_res == 0
            if pumvisible()
                return "\<C-n>"
            else
                call UltiSnips_JumpForwards()
                if g:ulti_jump_forwards_res == 0
                return "\<TAB>"
                endif
            endif
        endif
        return ""
    endfunction

    augroup ultisnips_ycm
        au BufEnter * exec "inoremap <silent> " . g:UltiSnipsExpandTrigger . " <C-R>=g:UltiSnips_Complete()<cr>"
    augroup END
endif

let g:jedi#goto_command = "gd"
let g:jedi#get_definition_command = "<leader>`"
let g:jedi#use_tabs_not_buffers = 0

if has("autocmd") && exists(":RainbowParenthesesToggle")
    augroup rainbowparentheses
        au!
        au VimEnter * RainbowParenthesesToggle
        au Syntax * RainbowParenthesesLoadRound
        au Syntax * RainbowParenthesesLoadSquare
        au Syntax * RainbowParenthesesLoadBraces
    augroup END
endif

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

            exec 'edit ' . a:qargs
        elseif winwidth(0) >= (79 + padding) * 2
            exec 'vsplit ' . a:qargs
            wincmd L
        else
            exec 'split ' . a:qargs
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
        au!

        " Keep splits equal on resize
        autocmd VimResized * :wincmd =

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
    au!
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
    au!
    autocmd BufNewFile,BufRead * setlocal formatoptions-=ro
    autocmd BufNewFile,BufRead * silent! setlocal formatoptions+=j
augroup END

let g:tex_flavor='latex'
