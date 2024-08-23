vim.wo.signcolumn = 'yes'

-- Match mathlib's default style.
vim.bo.textwidth = 100

vim.keymap.set('n', '<LocalLeader>g', function()
    require'telescope.builtin'.live_grep{
      path_display = { 'tail' },
      search_dirs = require('lean').current_search_paths()
    }
  end,
  { buffer = true }
)

vim.cmd.highlight('link leanTactic Green')
