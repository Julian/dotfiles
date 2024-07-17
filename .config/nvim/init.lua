vim.o.modeline = false

vim.g.mapleader = ' '
vim.g.maplocalleader = vim.g.mapleader .. vim.g.mapleader

if vim.env.TERM ~= 'xterm-256color' or vim.env.TERMUX_HOME ~= '' then
  vim.o.termguicolors = true
end

local uv = vim.uv or vim.loop

-- Spelling --

vim.o.spellfile = vim.fn.stdpath('config') .. '/spellfile.add'

-- Plugins --

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not uv.fs_stat(lazypath) then
  vim.fn.system{
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable',
    lazypath,
  }
end
vim.opt.runtimepath:prepend(lazypath)

require('lazy').setup('plugins', {
  defaults = { lazy = true },
  dev = {
    path = vim.env.DEVELOPMENT,
    patterns = { 'Julian/' },
    fallback = true,
  },
})

vim.o.gdefault = true
vim.o.lazyredraw = true               -- no redraw during macros (much faster)
vim.o.linebreak = true
vim.o.report = 0                      -- :cmd always shows changed line count
vim.o.textwidth = 79

vim.o.wrap = false
vim.o.showbreak = '↪   '

vim.opt.fillchars:append('diff:·')
vim.opt.isfname:remove('=')             -- this is probably an assignment

vim.opt.tags:append('.git/tags;$HOME')  -- look upward until $HOME for tags

-- Completion --

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

vim.o.pumblend = 5                    -- slightly transparent pum window
vim.opt.suffixes:append{ '.backup', '.hbm', '.ini' }  -- lower priority
vim.opt.wildmode = { 'longest:full', 'full' }

-- Really I want wildsmartcase (which doesn't exist), but I don't want to hit
-- longest: if my match was because of case insensitivity.
vim.o.wildignorecase = true

vim.opt.wildignore:append {
  '*.db', '*.o', '*.obj',
  '*.swp', '*.bak', '*.lock',
  '*.git', '*.hg', '*.svn',
  'MANIFEST', '*.pyc', '**/_trial_temp*/**', '*.egg-info/**', '*.egg/**',
  '**/build/**', '**/htmlcov/**', '**/dist/**', '**/_build/**',
  '**/.tox/**', '**/.nox/**', '**/.testrepository/**',
  '**/.vim-flavor/**',
  '*DS_Store*',
  'version.txt',
  '**/tmp/**',
  '*.png', '*.jpg', '*.gif', '*.svg',
  '*.app', '*.dmg', '*.pdf', '*.so',
  '**/.gems/**', '**/.chef/checksums/**',
}


if vim.fn.executable('rg') then
  vim.o.grepprg = 'rg --hidden --vimgrep --no-heading --smart-case $*'
  vim.o.grepformat = '%f:%l:%c:%m,%f:%l:%m'
elseif vim.fn.filereadable('/usr/local/bin/grep') then  -- newer grep
  vim.o.grepprg = '/usr/local/bin/grep'
end

uv.fs_open('/usr/share/dict/words', 'r', 438, function(err, fd)
  if err then return end
  vim.schedule(function()
    vim.opt.dictionary:append('/usr/share/dict/words')
  end)
  uv.fs_close(fd)
end)

-- Folding --

vim.o.foldmethod = 'indent'
vim.o.foldlevel = 99

-- Guides --

vim.o.cursorline = true               -- highlight current line
vim.o.showmatch = true                -- show matching brackets for a moment
vim.opt.matchpairs:append('<:>')
vim.o.matchtime = 5                   -- how long? (*tenths* of second)

-- History --

vim.o.backup = true
vim.opt.backupdir = {
  vim.env.XDG_CACHE_HOME .. '/nvim/backups',
  '~/tmp',
  '/tmp',
}
vim.o.undofile = true

-- Interface --

vim.o.confirm = true            -- dialog instead of warning
vim.opt.shortmess:append('actI')  -- show shorter messages
vim.o.title = true              -- change title to filename
vim.o.equalalways = true        -- hopefully fix how often :sp's mess up
vim.o.splitbelow = true         -- new :sp go on bottom
vim.o.splitright = true         -- new :vsp go on right

vim.o.winminheight = 0          -- allow totally minimizing a window

vim.o.timeoutlen = 500          -- shorten the amount of time to wait

vim.o.showtabline = 1

vim.o.winblend = 20             --  make floating windows transparentish

vim.opt.listchars = {
  tab = '▸ ',
  eol = '¬',
  trail = '·',
  extends = '→',
  precedes = '←',
}

IS_ANDROID = vim.env.ANDROID_ROOT ~= nil

vim.o.mousemodel = 'popup'
vim.o.mouse = IS_ANDROID and 'nv' or 'v'

vim.diagnostic.config{ severity_sort = true, float = { border = 'rounded' } }

-- Movement --

vim.o.startofline = false       -- never jump back to start of line

vim.o.scrolloff = 2             -- keep lines above and below cursor
vim.o.sidescrolloff = 2         -- same for horizontal

vim.o.virtualedit = 'block'

-- Search --

vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.tagcase = 'followscs'

-- Whitespace --

vim.o.expandtab = true        -- insert space instead of tab
vim.o.shiftround = true       -- rounds indent to a multiple of shiftwidth
vim.o.shiftwidth = 4          -- makes # of spaces = 4 for new tab
vim.o.softtabstop = 4         -- makes the spaces feel like tab
vim.o.tabstop = 8             -- makes # of spaces = 8 for preexisting tab

-- Bindings --

vim.cmd[[
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
  command! -bang X x<bang>
]]

local function keynop(modes, lhs) vim.keymap.set(modes, lhs, '') end
local function keyplug(modes, lhs, plug)
  vim.keymap.set(modes, lhs, '<Plug>(' .. plug .. ')')
end

keynop({ 'i', 'n' }, '<F1>')

-- Put exchange (and splitjoin) on s, use cl if you want that, but I rarely do.
keyplug({ 'n', 'v', 's' }, 's', 'Exchange')

-- Use arrow keys for diff-mode putting and getting
for key, value in pairs{
  ['<Up>'] = 'diffget<CR>[c',
  ['<Down>'] = 'diffget<CR>]c',
  ['<Left>'] = 'diffget<CR>',
  ['<Right>'] = 'diffput<CR>',
} do
  vim.keymap.set(
    'n', key,
    function() return vim.wo.diff and '<Cmd>' .. value or key end,
    { expr = true }
  )
end

-- don't use Ex mode, use Q for formatting
vim.keymap.set('n', 'Q', 'gqap')
vim.keymap.set('v', 'Q', 'gq')

-- change Y to act like C, D
vim.keymap.set('n', 'Y', 'y$')

-- Swap ; and : and ` and '
vim.keymap.set({ 'n', 'v' }, ':', ';')
vim.keymap.set({ 'n', 'v' }, ';', ':')
vim.keymap.set({ 'n', 'v' }, 'q;', 'q:')
vim.keymap.set('n', "'", '`')
vim.keymap.set('n', '`', "'")
vim.keymap.set('n', "g'", 'g`')
vim.keymap.set('n', 'g`', "g'")
vim.keymap.set('n', "]'", ']`')
vim.keymap.set('n', ']`', "]'")

-- lua command mode
vim.keymap.set('n', '<C-;>', ':lua ')

-- Preserve flags for &, and add it in visual mode.
vim.keymap.set({ 'n', 'x' }, '&', ':&&<CR>')

-- Clear whatever is going on.
vim.keymap.set(
  'n', '<C-L>', function()
    vim.cmd[[
      nohlsearch
      syntax sync fromstart
      XchangeClear
      LinediffReset
      QuickhlManualReset
    ]]
    vim.schedule(function()
      vim.cmd.diffupdate()
      require('notify').dismiss()
    end)
    vim.lsp.buf.clear_references()
    return '<C-L>'
  end,
  { expr = true }
)

-- testing mappings
vim.keymap.set('n', 'd<CR>', function()
  local name = vim.fn.expand('%')
  return '<Cmd>SplitSensibly ' .. vim.fn['runt#find_test_file_for'](name) .. '<CR>'
end, { expr = true })
vim.keymap.set('n', 'dK', vim.fn['runt#follow'])

vim.keymap.set('n', '<leader>ttd', function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end)

-- Filetypes --

vim.filetype.add{
  extension = {
    gyp = 'python',
    j2 = 'python',
    jinja2 = 'python',
    tac = 'python',
    mako = 'html',
    mak = 'html',
  },
  filename = {
    Gemfile = 'ruby',
  },
  pattern = {
    ['.*/test/corpus/.*.txt'] = 'tree-sitter-test',
  }
}
vim.api.nvim_create_autocmd('BufReadCmd', {
  pattern = { '*.egg', '*.whl' },
  command = [[call zip#Browse(expand("<amatch>"))]],
})

-- Formatting --

if vim.fn.executable('par') then
  vim.o.formatprg = 'par'
end

-- Miscellaneous --

vim.g.python3_host_prog = vim.env.HOME .. '/.local/share/virtualenvs/neovim/bin/python3'
vim.g.is_posix = 1
vim.g.tex_flavor = 'latex'

-- UI --

vim.api.nvim_create_autocmd('UIEnter', {
  callback = function(ev)
    local ui = vim.api.nvim_get_chan_info(ev.id)
    if ui.client and ui.client.name and ui.client.name == "Firenvim" then
      vim.o.laststatus = 0
      vim.o.ruler = false

      vim.o.spell = true
      vim.o.textwidth = 0
      vim.o.wrap = true

      -- Display lines make a bit more sense to me for this use case.
      vim.keymap.set('n', 'j', 'gj')
      vim.keymap.set('n', 'k', 'gk')
      vim.keymap.set('n', '$', 'g$')
      vim.keymap.set('n', '<Up>', 'k')
      vim.keymap.set('n', '<Down>', 'j')
      vim.keymap.set('n', '<Right>', '$')

      vim.api.nvim_create_autocmd({ 'FocusLost', 'InsertLeave' }, {
        pattern = '*',
        command = '++nested write',
      })

      vim.keymap.set('n', '<D-a>', 'ggVG')
      vim.keymap.set('i', '<D-a>', '<C-o>gg<C-o>VG')
      vim.keymap.set('n', '<D-v>', '"*p')
      vim.keymap.set('i', '<D-v>', '<C-o>"*p')

      vim.cmd.startinsert()
    end
  end
})

-- Globals --

local statfs = uv.fs_statfs(vim.fn.expand("$MYVIMRC"))  -- < 5GB left
_G.SMALL_FILESYSTEM = (statfs.bavail * statfs.bsize) < 5 * 1024 * 1024 * 1024

_G.q = vim.print
vim.cmd[[command! -nargs=1 -complete=lua Q lua q(<args>)]]

--- The parent dir of the current buffer if it has a name, otherwise cwd.
function _G.parent_or_cwd()
  local name = vim.fn.expand('%:h')
  if name == "" then return vim.fn.getcwd() end
  return name
end

-- Jump to next diagnostic, showing the float if it's not likely to already be
-- visible in the virtual text.
vim.keymap.set('n', '[d', function()
  local diagnostic = vim.diagnostic.get_prev()
  if not diagnostic then return end
  local float = diagnostic.message:find('\n') and { header = false } or false
  vim.diagnostic.goto_prev{ float = float }
end)
vim.keymap.set('n', ']d', function ()
  local diagnostic = vim.diagnostic.get_next()
  if not diagnostic then return end
  local float = diagnostic.message:find('\n') and { header = false } or false
  vim.diagnostic.goto_next{ float = float }
end)

vim.keymap.set('n', '<leader>i', function()
  local cwd = vim.fn.getcwd()
  local jumplist, current = unpack(vim.fn.getjumplist())
  for position = current, #jumplist, 1 do
    local jump = jumplist[position]
    local path = vim.api.nvim_buf_get_name(jump.bufnr)
    if vim.startswith(path, cwd) then
      return vim.api.nvim_win_set_buf(0, jump.bufnr)
    end
  end
end, { desc = 'Jump to the last entry in the jumplist which is a child of the current working directory.' })

vim.keymap.set('n', '<leader>o', function()
  local cwd = vim.fn.getcwd()
  local jumplist, current = unpack(vim.fn.getjumplist())
  for position = current - 1, 1, -1 do
    local jump = jumplist[position]
    local path = vim.api.nvim_buf_get_name(jump.bufnr)
    if vim.startswith(path, cwd) then
      return vim.api.nvim_win_set_buf(0, jump.bufnr)
    end
  end
end, { desc = 'Jump to the next entry in the jumplist which is a child of the current working directory.' })


vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)

vim.keymap.set('n', '<leader>K', function()
    vim.diagnostic.open_float{ scope = "line", header = '', focus = false }
end, { desc = 'show information about line diagnostics in a float' })

vim.keymap.set('n', '<leader>tl', function()
  vim.wo.list = not vim.wo.list
end)
vim.keymap.set('n', '<leader>tn', function ()
  vim.wo.number = not vim.wo.number
  vim.wo.relativenumber = not vim.wo.relativenumber
end, { desc = 'toggle line numbers of all kinds' })

vim.keymap.set('n', '<leader>tS', function ()
  -- FIXME: We aren't actually toggling.
  vim.o.laststatus = 0
  vim.api.nvim_set_hl(0 , 'Statusline', { link = 'Normal' })
  vim.api.nvim_set_hl(0 , 'StatuslineNC', { link = 'Normal' })
  vim.o.statusline = ('-'):rep(vim.api.nvim_win_get_width(0))
end, { desc = 'toggle screenshot mode' })

-- To Port --

vim.cmd[[
" delete a surrounding function call (which surround doesn't support OOTB)
nmap dsc :call search('\<', 'bc')<CR>dt(ds)

" quote a word
nmap <expr> yq 'ysiw' . (get(b:, 'use_single_quotes', 0) ? "'" : '"')

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

nnoremap  <expr><leader><CR>      '<Cmd>autocmd BufWritePost <buffer> !' . input('command: ', '', 'shellcmd') . '<CR>'

"               <leader>a         LSP code action
nnoremap        <leader>b         o<C-R>"<Esc>
nnoremap        <leader>d         <Cmd>lua require('telescope.builtin').find_files{ hidden = true }<CR>
nnoremap        <leader>e         :<C-U>SplitSensibly<CR>:lua require('telescope.builtin').find_files{ search_dirs = { "" } }<Left><Left><Left><Left><Left>
nnoremap        <leader>f         <Cmd>lua require('telescope.builtin').find_files{ hidden = true, search_dirs = { parent_or_cwd() } }<CR>
"               <leader>g         Git
nnoremap        <leader>h         <Cmd>lua require('telescope.builtin').tags{ only_sort_tags = true }<CR>
"               <leader>i         jump_to_last
nnoremap        <leader>j         <Cmd>lua require('telescope.builtin').tags{ default_text = 'test' }<CR>
nnoremap        <leader>k         <Cmd>lua require('telescope.builtin').lsp_document_symbols()<CR>
nnoremap        <leader>l         <Cmd>lua require('telescope.builtin').current_buffer_fuzzy_find()<CR>
nmap            <leader>m         <Plug>(quickhl-manual-this)
"               <leader>n         goto next diagnostic
"               <leader>o         jump_to_next
nnoremap        <leader>p         "*p
"               <leader>q         set loclist to diagnostics
nnoremap        <leader>r         <Cmd>lua require('telescope.builtin').registers{}<CR>
nnoremap        <leader>s         <Cmd>Switch<CR>
"               <leader>t         Togglers
nnoremap        <leader>u         :<C-U>set cpoptions+=u<CR>u:w<CR>:set cpoptions-=u<CR>
nnoremap        <leader>v         <Cmd>SplitSensibly $MYVIMRC<CR>
nnoremap        <leader>w         <Cmd>lua require('telescope.builtin').lsp_dynamic_workspace_symbols()<CR>
nnoremap        <leader>y         "*y
"               <leader>z         LSP formatting

nnoremap        <leader>ga         <Cmd>Git difftool<CR>
nnoremap        <leader>gb         <Cmd>Git blame<CR>
nnoremap        <leader>gc         <Cmd>Git commit<CR>
nnoremap        <leader>gd         <Cmd>Gdiffsplit<CR>
nnoremap        <leader>gf         <Cmd>Git difftool -y<CR>
nnoremap        <leader>ge         <Cmd>Gedit<CR>
nnoremap        <leader>gr         <Cmd>Gread<CR>
nnoremap        <leader>gs         <Cmd>Git<CR>
nnoremap        <leader>gw         <Cmd>Gwrite<CR>

"   <leader>t mappings are for togglers
"
nnoremap        <leader>ta        <Cmd>Vista!!<CR>
"               <leader>tb        DAP breakpoint
nnoremap        <leader>tc        <Cmd>DiffChangesDiffToggle<CR>
nnoremap        <leader>td        <Cmd>DiffThese<CR>
nnoremap        <leader>ti        <Cmd>IndentGuidesToggle<CR>
"               <leader>tl        list
"               <leader>tn        line numbering
nnoremap        <leader>tp        :<C-U>setlocal formatoptions-=c<CR>:setlocal spell!<CR>:setlocal wrap!<CR>:setlocal textwidth=0<CR>
nnoremap        <leader>ts        <Cmd>setlocal spell!<CR>
"               <leader>ttd       diagnostics
nnoremap        <leader>tth       <Cmd>TSBufToggle highlight<CR>
nnoremap        <leader>tti       <Cmd>Inspect<CR>
nnoremap        <leader>ttp       <Cmd>InspectTree<CR>
nnoremap        <leader>ttq       <Cmd>EditQuery<CR>
nnoremap        <leader>ttt       <Cmd>lua require('telescope.builtin').treesitter{}<CR>
nnoremap        <leader>tu        <Cmd>UndotreeToggle<CR>
nnoremap        <leader>tw        <Cmd>setlocal wrap!<CR>
nnoremap        <leader>tx        <Cmd>call ToggleExpando()<CR>
"               <leader>tS        screenshotting

nnoremap        <leader>B         o<C-R>*<Esc>
nnoremap        <leader>C         :<C-U>SplitSensibly<CR><Cmd>lua require('telescope.builtin').find_files{ default_text='.', hidden = true, source_dirs = { os.getenv('HOME'), os.getenv('XDG_CONFIG_HOME') } }<CR>
nnoremap        <leader>D         <Cmd>lua require('telescope.builtin').diagnostics{ bufnr = 0 }<CR>
nnoremap        <leader>F         <Cmd>lua require('telescope.builtin').lsp_references{}<CR>
nnoremap        <leader>J         <Cmd>lua require('telescope.builtin').find_files{ default_text = 'test' }<CR>
"               <leader>K         show line diagnostics
"               <leader>L         LSP folder management and other mappings
"               <leader>N         goto previous diagnostic
nnoremap  <expr><leader>O         EditFileWORD()
nnoremap        <leader>P         "*P
"               <leader>R         LSP rename
nnoremap        <leader>S         :<C-U>%s/\s\+$//<cr>:let @/=''<CR>
nnoremap        <leader>U         :<C-U>Lazy update<CR>:TSUpdate<CR>
nnoremap        <leader>V         <Cmd>SplitSensibly $MYVIMRC<CR>
nnoremap        <leader>Y         "*y$
nnoremap        <leader>Z         <Cmd>SplitSensibly $ZDOTDIR/.zshrc<CR>

"               <leader>D         DAP
nnoremap        <leader>DD        :<C-U>profile start profile.log<CR>:profile func *<CR>:profile file *<CR>
nnoremap        <leader>DQ        :<C-U>profile pause<CR>:noautocmd quitall!<CR>

nnoremap  <expr><leader>VF        "<Cmd>SplitSensibly " . split(&runtimepath, ",")[0] .  "/after/ftplugin/" . &filetype . ".lua<CR>"
nnoremap        <leader>VZ        <Cmd>SplitSensibly $ZDOTDIR/.zshrc.local<CR>

nnoremap        <leader>0         <Cmd>wincmd _<CR>


nnoremap        <leader>`         <Cmd>call DoCommentTagFormat()<CR>
nnoremap        <leader>.         <Cmd>setlocal autochdir<CR>
nnoremap        <leader>;         <Cmd>lprevious<CR>
nnoremap        <leader>'         <Cmd>lnext<CR>
nnoremap        <leader>[         <Cmd>cprevious<CR>
nnoremap        <leader>]         <Cmd>cnext<CR>
nnoremap        <leader>{         <Cmd>cpfile<CR>
nnoremap        <leader>}         <Cmd>cnfile<CR>
nnoremap        <leader>-         <Cmd>previous<CR>
nnoremap        <leader>=         <Cmd>next<CR>
nnoremap        <leader>_         <Cmd>tabprevious<CR>
nnoremap        <leader>+         <Cmd>tabnext<CR>
nnoremap        <leader><BS>      <Cmd>earlier 1f<CR>
nnoremap        <leader>\         <Cmd>later 1f<CR>
nnoremap        <leader>/         <Cmd>lua require('telescope.builtin').live_grep{ additional_args = { '--hidden' } }<CR>
nnoremap        <leader>?         <Cmd>lua require('telescope.builtin').grep_string{ cwd = require('telescope.utils').buffer_dir() }<CR>


nnoremap        <leader><tab>     <C-^>


vnoremap        <leader>d         <Cmd>Linediff<CR>
vmap            <leader>m         <Plug>(quickhl-manual-this)
vnoremap        <leader>p         "*p
vnoremap        <leader>y         "*y


" ============
" : Autocmds :
" ============

  " diffthis with some sugar
  function! DiffTheseCommand()
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

  command! DiffThese call DiffTheseCommand()

  " Split a window vertically if it would have at least 79 chars plus a bit
  " of padding, otherwise split it horizontally
  function! SplitSensiblyCommand(qargs)
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
      call SplitSensiblyCommand(a:path)
  endfunction

  command! -nargs=* -complete=file SplitSensibly call SplitSensiblyCommand('<args>')
  command! -nargs=* -complete=file Ss call SplitSensiblyCommand('<args>')
  command! -nargs=* -complete=file SS call SplitSensiblyCommand('<args>')

  " If we're in a real file, enable colorcolumn.
  function! WindowWidth()
      if &buftype == 'nofile'
          return
      else
          " show a line at column 80
          setlocal colorcolumn=+1
      endif
  endfunction

  " Expand the active window
  function! ToggleExpando()
      if !exists("s:expando_enabled")
          let s:expando_enabled = 0
          return ToggleExpando()
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

  function! DoCommentTagFormat()
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

  augroup misc
      autocmd!

      " Keep splits equal on resize
      autocmd VimResized * :wincmd =

      " Automagic line numbers
      autocmd BufWinEnter,VimEnter * :call WindowWidth()

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
]]
