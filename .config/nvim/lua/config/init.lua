require('config.treesitter')
require('lean').setup{
  lsp = {
    cmd = {"lean-language-server", "--stdio", "--", "-M", "4096"},
    on_attach = require('config.lsp').attached,
  }
}
