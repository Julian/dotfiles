-- Match mathlib's default style.
vim.bo.textwidth = 100

vim.api.nvim_buf_set_keymap(
  0, "n", "<LocalLeader>g",
  "<Cmd>lua require'telescope.builtin'.live_grep{ search_dirs = require'lean'.current_search_paths() }<CR>",
  { noremap = true }
)
