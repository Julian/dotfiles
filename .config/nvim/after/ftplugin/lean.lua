vim.wo.signcolumn = 'yes'

-- Match mathlib's default style.
vim.bo.textwidth = 100

vim.keymap.set('n', '<LocalLeader>g', function()
  require'telescope.builtin'.live_grep{
    glob_pattern = '*.lean',
    path_display = { 'tail' },
    search_dirs = require('lean').current_search_paths()
  }
end, { buffer = true, desc = 'live grep the Lean search path.' })
vim.keymap.set('n', '<LocalLeader>l', function()
  require'telescope'.extensions.loogle.loogle{}
end, { buffer = true, desc = 'search Loogle via Telescope' })

vim.keymap.set('i', '<C-;>', function()
  require'telescope'.extensions.lean_abbreviations.lean_abbreviations{}
end, { buffer = true, desc = 'insert a unicode abbreviation' })
