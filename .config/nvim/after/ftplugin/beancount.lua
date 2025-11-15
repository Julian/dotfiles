vim.bo.commentstring = '; %s'

vim.bo.textwidth = 120

vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2

vim.b.switch_definitions = {
  vim.g.switch_builtins.true_false,
  { 'open', 'close' },
}

vim.keymap.set(
  'n', '<localleader>t',
  'oExpenses:Taxes:Sales                                       USD',
  { buffer = true, desc = 'Add a sales tax line.' }
)
