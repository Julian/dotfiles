require('config.completion')
require('config.lsp')
require('config.treesitter')

require('lean').setup{
  lsp = {
    cmd = {"lean-language-server", "--stdio", "--", "-M", "4096"},
    on_attach = require('config.lsp').on_attach,
  }
}
