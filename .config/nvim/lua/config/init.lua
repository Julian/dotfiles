require('config.completion')
require('config.lsp')
require('config.treesitter')

require('lean').setup{
  lsp = {
    cmd = {"frankenlean", "-M", "4096"},
    on_attach = require('config.lsp').on_attach,
  }
}

require('nvim-treesitter.parsers').get_parser_configs().lean = {
  install_info = {
    url = "https://github.com/Julian/tree-sitter-lean",
    files = {"src/parser.c", "src/scanner.cc"},
    branch = "main",
  },
  filetype = "lean",
}

require('nvim-treesitter.configs').setup{
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
  }
}
