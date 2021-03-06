require('config.completion')
require('config.lsp')
require('config.treesitter')

require('lean').setup{
  lsp = {
    cmd = {"frankenlean", "-M", "4096"},
    on_attach = require('config.lsp').on_attach,
  }
}

require('nvim-treesitter.configs').setup{
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
  }
}
