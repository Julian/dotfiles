vim.bo.makeprg = 'glow %'
vim.bo.textwidth = 0
vim.wo.wrap = true
vim.opt_local.formatoptions:remove('c')

vim.keymap.set({'n'}, '<localleader>h', '0i# ', { buffer = true })
