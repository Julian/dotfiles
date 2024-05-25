vim.bo.makeprg = 'rst2html.py %'
vim.bo.textwidth = 0
vim.wo.wrap = true
vim.opt_local.formatoptions:remove('c')

vim.keymap.set({'n'}, '<localleader>_', 'yypVr-', { buffer = true })
vim.keymap.set({'n'}, '<localleader>+', 'yypVr=', { buffer = true })
vim.keymap.set({'n'}, '<localleader>6', 'yypVr^', { buffer = true })
vim.keymap.set({'n'}, '<localleader>-', 'yyPVr-yyjp', { buffer = true })
vim.keymap.set({'n'}, '<localleader>=', 'yyPVr=yyjp', { buffer = true })
