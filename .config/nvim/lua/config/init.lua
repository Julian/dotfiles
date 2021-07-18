require('config.completion')
require('config.lsp')

function _G.q(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
  return ...
end

require('lean').setup{
  abbreviations = { builtin = true },
  lsp = { on_attach = require('config.lsp').on_attach },
  lsp3 = { on_attach = require('config.lsp').on_attach },
  mappings = true,
}

require('nvim-treesitter.configs').setup{
  ensure_installed = "maintained",
  highlight = { enable = true },
  indent = { enable = true },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = {"BufWrite", "CursorHold"},
  },
  textobjects = {
    select = {
      enable = true,
      keymaps = {
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["ac"] = "@class.outer",
        ["ic"] = "@class.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
      },
    },
  }
}
