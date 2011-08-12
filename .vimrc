set nocompatible                       " turn off vi compatible, should be first

" ============
" : Mappings :
" ============

let mapleader=","

" quick fingers
cnoreabbrev WQ wq
cnoreabbrev Wq wq
cnoreabbrev W w
cnoreabbrev Q q

" CHECKME
" don't use Ex mode, use Q for formatting
" map Q gq

" change Y to act like C, D
map Y y$

" swap ' and `
noremap ' `
noremap ` '
noremap g' g`
noremap g` g'
" sunmap ' sunmap ` sunmap g' sunmap g`

" reverse line join
nnoremap <Leader>J ddpkJ

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

" fix syntax highlighting errors
noremap <F12> <Esc>:syntax sync fromstart<CR>
inoremap <F12> <C-o>:syntax sync fromstart<CR>

" PEP8
let g:pep8_map='<leader>8'

map <leader>a :TlistToggle<CR>
map <leader>f :CommandT<CR>
map <leader>g :GundoToggle<CR>
map <leader>k <Esc>:Ack!<CR>
map <leader>l :set list!<CR>
map <leader>n :NERDTreeToggle<CR>
map <leader>p :Lodgeit<CR>
map <leader>t :CommandT
map <leader>td <Plug>TaskList
map <leader>y :set spell!<CR>
map <leader>z :vsp ~/.zshrc<CR><C-W>_

map <leader>tb :ConqueTermSplit bpython<CR>
map <leader>tB :ConqueTermVSplit bpython<CR>
map <leader>tc :ConqueTermSplit bpython-3.2<CR>
map <leader>tC :ConqueTermVSplit bpython-3.2<CR>
map <leader>tt :ConqueTermSplit zsh<CR>
map <leader>tT :ConqueTermVSplit zsh<CR>
map <leader>to :ConqueTermSplit python3<CR>
map <leader>tO :ConqueTermVSplit python3<CR>
map <leader>tp :ConqueTermSplit python<CR>
map <leader>tP :ConqueTermVSplit python<CR>

map <leader>j :RopeGotoDefinition<CR>
map <leader>r :RopeRename<CR>

map <leader>N :set makeprg=nosetests\|:call MakeGreen()<CR>
map <leader>O :set makeprg=nosetests3\|:call MakeGreen()<CR>

map <leader>3 :set guifont=Inconsolata:h12<CR>:vsp<CR>:vsp<CR>

" ============
" : Pathogen :
" ============

filetype off
call pathogen#helptags()
call pathogen#runtime_append_all_bundles()

" =========
" : Basic :
" =========

syntax on
filetype on
filetype plugin indent on

set encoding=utf8
set hidden
set history=100		               " command line history
set lazyredraw                         " no redraw during macros (much faster)
set linebreak
set nowrap
set report=0                           " :cmd always shows changed line count
set undolevels=500                     " more undo

" CHECKME: Is this good for non OSX too
set clipboard+=unnamed                 " share clipboard with system clipboard

" CHECKME
" Disable the colorcolumn when switching modes.  Make sure this is the
" first autocmd for the filetype here
" autocmd FileType * setlocal colorcolumn=0

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

" ==========
" : Indent :
" ==========

set autoindent

" =============
" : Interface :
" =============

set t_Co=256
colorscheme molokai

set background=dark

set backupdir=~/.vim/sessions,~/tmp,/tmp    " put backups and...
set directory=~/.vim/sessions,~/tmp,/tmp    " swap files here instead of .

set guifont=Inconsolata:h14
set guioptions-=T
set guioptions-=L
set guioptions-=r

set laststatus=2                       " always show status line
set statusline=[%l,%v\ %P%M]\ %f\ %r%h%w\ (%{&ff})\ %{fugitive#statusline()}

set confirm                            " show confirm dialog instead of warn
set listchars=tab:>-,eol:$,trail:-,precedes:<,extends:>
set shortmess+=atI                     " show shorter messages
set spell                              " spell checking
set title                              " change window title to filename

" no bells or blinking
set noerrorbells
set vb t_vb=

" VERIFYME
if has("gui_running")
    set fuoptions=maxvert,maxhorz
    au GUIEnter * set fullscreen
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
set virtualedit=block

" ==========
" : Search :
" ==========

set ignorecase
set smartcase                          " case-sensitive if upper in search term
set incsearch		               " do incremental searching
set hlsearch                           " hilight searches

" ==============
" : Whitespace :
" ==============

set expandtab               " insert space instead of tab 
set shiftround              " rounds indent to a multiple of shiftwidth
set shiftwidth=4            " makes # of spaces = 4 for new tab
set softtabstop=4           " makes the spaces feel like tab
set tabstop=8               " makes # of spaces = 8 for preexisitng tab
"
" ===================
" : Plugin Settings :
" ===================

" Navigate using hjkl
let g:miniBufExplMapWindowNavVim = 1

let Tlist_Ctags_Cmd = '/usr/local/bin/ctags'

" =====================
" : FileType Specific :
" =====================

" HTML/Mako
autocmd BufNewFile,BufRead *.mako,*.mak setlocal ft=html
autocmd FileType html,xhtml,xml setlocal expandtab shiftwidth=2 tabstop=2 softtabstop=2

" CSS
autocmd FileType css setlocal expandtab shiftwidth=4 tabstop=4 softtabstop=4

" Python
"au BufRead *.py compiler nose
au FileType python set omnifunc=pythoncomplete#Complete
let g:SuperTabDefaultCompletionType = "context"

au FileType python setlocal expandtab textwidth=79 shiftwidth=4 tabstop=8 softtabstop=4 cinwords=if,elif,else,for,while,try,except,finally,def,class,with
au BufRead *.py set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
let python_highlight_all=1

" TODO: Mapping / something to split 2 windows at 79 chars, toggling the right
" one on and off (like a test_ file), with tags (,a) at the left
