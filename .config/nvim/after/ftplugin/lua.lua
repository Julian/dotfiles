vim.bo.softtabstop = 2
vim.bo.shiftwidth = 2

vim.b.switch_definitions = {
  { 'is_true', 'is_false' },
  { 'truthy', 'falsy' },
  vim.fn['switch#Words']({ 'pending', 'it' })
}

vim.b.use_single_quotes = true
