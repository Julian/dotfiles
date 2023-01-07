vim.diagnostic.config{ severity_sort = true, float = { border = 'rounded' } }

vim.notify = require('notify')
vim.notify.setup{
  max_width = 100,
}

vim.keymap.set('n', '<leader>ttd', function()
  if vim.b.diagnostics_hidden then
    vim.diagnostic.show(nil, 0)
  else
    vim.diagnostic.hide(nil, 0)
  end
  vim.b.diagnostics_hidden = not vim.b.diagnostics_hidden
end)
