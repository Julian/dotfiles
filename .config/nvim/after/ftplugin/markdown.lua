vim.bo.shiftwidth = 2
vim.bo.softtabstop = 2

vim.bo.makeprg = 'glow %'
vim.bo.textwidth = 0
vim.wo.wrap = true
vim.opt_local.formatoptions:remove('c')

vim.keymap.set({'n'}, '<localleader>h', '0i# ', { buffer = true })

vim.wo.conceallevel = 1  -- for obsidian.nvim
