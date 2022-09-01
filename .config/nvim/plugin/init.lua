vim.diagnostic.config{ severity_sort = true, float = { border = 'rounded' } }

vim.notify = require('notify')
vim.notify.setup{
  max_width = 100,
}

local diagnostics_active = true
vim.keymap.set('n', '<leader>ttd', function()
  if diagnostics_active then vim.diagnostic.hide() else vim.diagnostic.show() end
  diagnostics_active = not diagnostics_active
end)
