vim.diagnostic.config{ severity_sort = true }
vim.notify = require('notify')
vim.opt.laststatus = 3


--- The parent dir of the current buffer if it has a name, otherwise cwd.
function _G.parent_or_cwd()
  local name = vim.fn.expand('%:h')
  if name == "" then return vim.fn.getcwd() end
  return name
end
