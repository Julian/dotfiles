set nocompatible                       " turn off vi compatible, should be first

" ==========
" : Vundle :
" ==========

filetype off
set runtimepath+=~/.vim/bundle/vundle/
call vundle#rc()

" let Vundle manage Vundle (required!)
Bundle 'gmarik/vundle'

" themes
" Bundle 'KevinGoodsell/vim-csexact'
Bundle 'sickill/vim-monokai'

" temporary stuff
Bundle 'dahu/VimRegexTutor'

" permanent stuff
Bundle 'alfredodeza/coveragepy.vim'
Bundle 'ervandew/supertab'
Bundle 'Lokaltog/vim-powerline'
Bundle 'majutsushi/tagbar'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'mikewest/vimroom'
Bundle 'scrooloose/nerdtree'
Bundle 'SirVer/ultisnips'
Bundle 'sontek/rope-vim'
Bundle 'tomtom/tcomment_vim'
Bundle 'tpope/vim-fugitive'
Bundle 'tpope/vim-git'
Bundle 'tpope/vim-repeat'
Bundle 'tpope/vim-surround'
Bundle 'tpope/vim-unimpaired'

" HTML5 / CSS / JS / Coffee
Bundle 'groenewege/vim-less'
Bundle 'hail2u/vim-css3-syntax'
Bundle 'kchmck/vim-coffee-script'
Bundle 'othree/html5.vim'
" Bundle 'skammer/vim-css-color'

Bundle 'Conque-Shell'
Bundle 'jpythonfold.vim'
Bundle 'pep8'
" Bundle 'Pydiction'
Bundle 'TaskList.vim'
Bundle 'YankRing.vim'

Bundle 'pydave/AsyncCommand'
Bundle 'jimf/vim-red-green'
Bundle 'jimf/vim-async-make-green'

Bundle 'git://git.wincent.com/command-t.git'
Bundle 'git://vim-latex.git.sourceforge.net/gitroot/vim-latex/vim-latex'

" disabled / saved for later
" Bundle 'reinh/vim-makegreen'
" Bundle 'orftz/sbd.vim'
" Bundle 'sjl/gundo.vim'

" =========
" : Basic :
" =========

filetype plugin indent on
syntax on

set encoding=utf8
set autoread                           " automatically reload unmodified bufs
set gdefault
set hidden
set lazyredraw                         " no redraw during macros (much faster)
set linebreak
set nowrap
set report=0                           " :cmd always shows changed line count

set clipboard+=unnamed                 " share clipboard with system clipboard
set pastetoggle=<F2>                   " use f2 to toggle paste mode

set tags=./tags;$HOME                  " look up until $HOME for tags

" CHECKME
" Disable the colorcolumn when switching modes.  Make sure this is the
" first autocmd for the filetype here
" autocmd FileType * setlocal colorcolumn=0

" ============
" : Bindings :
" ============

let mapleader=","

" quick fingers
cnoreabbrev WQ wq
cnoreabbrev Wq wq
cnoreabbrev W w
cnoreabbrev Q q

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

" reverse line join
nnoremap <leader>J ddpkJ

" toggle fold
nnoremap <space> za

" line numbers
nmap <C-N><C-N> :set invnumber<CR>
highlight LineNr term=bold cterm=NONE ctermfg=LightGrey gui=NONE guifg=LightGrey

" set working directory
nnoremap <leader>. :lcd %:p:h<CR>

" Fix broken # behavior
inoremap # X#

" recover from accidental c-u
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <c-g>u<c-w>

" completion
inoremap <expr> <Esc>      pumvisible() ? "\<C-e>" : "\<Esc>"
" TODO: add back <CR> map (see vim tips wiki), but I'm getting a bug
inoremap <expr> <Down>     pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr> <Up>       pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr> <PageDown> pumvisible() ? "\<PageDown>\<C-p>\<C-n>" : "\<PageDown>"

" tabs
nmap <C-S-tab> :tabprevious<CR>
nmap <C-tab> :tabnext<CR>
map <C-S-tab> :tabprevious<CR>
map <C-tab> :tabnext<CR>
imap <C-S-tab> <Esc>:tabprevious<CR>i
imap <C-tab> <Esc>:tabnext<CR>i

" unbind cursor keys
for prefix in ['i', 'n', 'v']
  for key in ['<Up>', '<Down>', '<Left>', '<Right>']
    exe prefix . "noremap " . key . " <Nop>"
  endfor
endfor

" ,v open .vimrc, ,V reloads (save first)
map <leader>v :vsp ~/.vimrc<CR><C-W>_
" TODO: Use winwidth() to :sp instead if window width would be less than a " half
map <silent> <leader>V :source ~/.vimrc<CR>:filetype detect<CR>:exe ":echo 'vimrc reloaded'"<CR>

" VERIFYME: change to toggle
" open/close the quickfix window
nmap <leader>c :copen<CR>
nmap <leader>cc :cclose<CR>

" hide matches
nnoremap <leader><space> :nohlsearch<cr>

" Remove trailing whitespace
nnoremap <leader>S :%s/\s\+$//<cr>:let @/=''<CR>

" Toggle how long lines are displayed
map <F11> :set wrap!<CR>

" fix syntax highlighting errors
noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>

map <leader>a :TagbarToggle<CR>
nmap <leader>d <C-W>0_
nmap <leader>f :NERDTreeToggle<CR>:TagbarToggle<CR>
map <leader>g :GundoToggle<CR>
map <leader>l :set list!<CR>
map <leader>n :NERDTreeToggle<CR>
map <leader>s :!trial %<CR>
map <leader>p :Lodgeit<CR>
map <leader>td <Plug>TaskList
map <leader>tt :CommandT<CR>
nnoremap <leader>w :VimroomToggle<CR>
map <leader>y :set spell!<CR>
map <leader>z :vsp ~/.zshrc<CR><C-W>_

map <leader>tb :ConqueTermSplit bpython<CR>
map <leader>tB :ConqueTermVSplit bpython<CR>
map <leader>tc :ConqueTermSplit bpython-3.2<CR>
map <leader>tC :ConqueTermVSplit bpython-3.2<CR>
map <leader>tz :ConqueTermSplit zsh<CR>
map <leader>tZ :ConqueTermVSplit zsh<CR>
map <leader>to :ConqueTermSplit python3<CR>
map <leader>tO :ConqueTermVSplit python3<CR>
map <leader>tp :ConqueTermSplit python<CR>
map <leader>tP :ConqueTermVSplit python<CR>

map <leader>j :RopeGotoDefinition<CR>
map <leader>r :RopeRename<CR>

map <leader>N :set makeprg=nosetests\|:call MakeGreen()<CR>
map <leader>O :set makeprg=nosetests3\|:call MakeGreen()<CR>

map <leader><leader> :b#<CR>

" reST / similar surround a line with -- and ==
nnoremap <leader>m- yyPVr-
nnoremap <leader>m= yyPVr=

nnoremap <leader>M- yyPVr-yyjp
nnoremap <leader>M= yyPVr=yyjp

" ==============
" : Completion :
" ==============

" insert mode completion
set completeopt=menuone,longest,preview " follow type in autocomplete
set pumheight=6                        " Keep a small completion window

set showcmd		               " display incomplete commands

set wildmenu                           " file completion helper window
set wildmode=longest:full,full
set wildignore+=*.o,*.obj,*.swp,*.bak,*.git,*.pyc
set suffixes+=.backup

" close preview window automatically when we move around
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

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

set history=256		               " command line history
set viminfo='1000,f1,:1000,/1000       " more viminfo

set backup
set backupdir=~/.vim/sessions,~/tmp,/tmp    " put backups and...

set undodir=~/.vim/sessions,~/tmp,/tmp    " put backups and...
set undofile
set undolevels=500                     " more undo

set directory=~/.vim/sessions,~/tmp,/tmp    " swap files here instead of .

" =============
" : Interface :
" =============

set background=dark

if &t_Co > 8
    set t_Co=256
    colorscheme molokai                    " needs to be after set background
else
    colorscheme desert
endif


set formatoptions-=r                   " do not insert comment char after enter

set laststatus=2                       " always show status line
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

if has("gui_running")
    if has("gui_macvim")
        set fuoptions=maxvert,maxhorz
        set guifont=Inconsolata:h14
        au GUIEnter * set fullscreen
    elseif has("gui_gtk2")
        set guifont=Inconsolata\ 13
    endif

    set guioptions-=T
    set guioptions-=L
    set guioptions-=m
    set guioptions-=r

endif

if has('mouse')
  set mouse=a
  set mousemodel=popup
endif

" ============
" : Movement :
" ============

set backspace=indent,eol,start         " backspacing over everything in insert
set nostartofline                      " never jump back to start of line
set ruler		               " show the cursor position all the time

set scrolloff=2                        " keep lines above and below cursor
set sidescrolloff=2                    " same for horizontal

set virtualedit=block

" ==========
" : Search :
" ==========

set ignorecase
set smartcase                          " case-sensitive if upper in search term
set incsearch		               " do incremental searching
set hlsearch                           " hilight searches

if filereadable("/usr/local/bin/grep") " if there's a newer grep, use it
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

let g:pydiction_location = '$HOME/.vim/bundle/Pydiction'

let yankring_history_dir = '$HOME/.vim'
let yankring_history_file = '.yankring_history'

" NERDTree
let NERDTreeIgnore = ['^_trial_temp$', '^__pycache__$', '^htmlcov$', '^_\?build$', 'egg-info$', '\~$']

" vim-indent-guides
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 1
let g:indent_guides_start_level = 2

" Supertab
let g:SuperTabDefaultCompletionType = "context"  " try to guess completion
let g:SuperTabLongestEnhanced = 1                " enhanced longest complete
let g:SuperTabLongestHighlight = 1               " preselect first result

" Powerline
let g:Powerline_symbols = 'fancy'

" ============
" : Autocmds :
" ============

if has("eval")

    " If we're in a wide window, enable line numbers.
    fun! <SID>WindowWidth()
        if winwidth(0) > 90
            setlocal foldcolumn=2
            setlocal relativenumber
        else
            setlocal norelativenumber
            setlocal foldcolumn=0
        endif
    endfun

endif

if has("autocmd") && has("eval")

    " Automagic line numbers
    autocmd BufEnter * :call <SID>WindowWidth()

    " Always do a full syntax refresh
    autocmd BufEnter * syntax sync fromstart

    " For help files, make <Return> behave like <C-]> (jump to tag)
    autocmd FileType help nmap <buffer> <Return> <C-]>

endif


" =====================
" : FileType Specific :
" =====================

autocmd BufNewFile,BufRead *.j2 setlocal filetype=jinja
autocmd BufNewFile,BufRead *.mako,*.mak setlocal filetype=html
autocmd BufNewFile,BufRead *.tac setlocal filetype=python

autocmd FileType html,xhtml,xml setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2
autocmd FileType css setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

autocmd FileType tex setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2 iskeyword+=: textwidth=79

autocmd Filetype rst setlocal expandtab textwidth=79 makeprg=rst2html.py\ %

" Compile coffeescript on write (requires vim-coffee-script)
autocmd BufWritePost *.coffee silent CoffeeMake!
autocmd FileType coffee setlocal textwidth=79

autocmd FileType python set omnifunc=pythoncomplete#Complete
autocmd FileType python setlocal expandtab textwidth=79 shiftwidth=4 tabstop=8 softtabstop=4 indentkeys-=<:>,0# cinwords=if,elif,else,for,while,try,except,finally,def,class,with
autocmd BufRead *.py set errorformat=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m

let g:tex_flavor='latex'
let python_highlight_all=1


" TODO: Mapping / something to split 2 windows at 79 chars, toggling the right
" one on and off (like a test_ file), with tags (,a) at the left
