if vim.g.loaded_nvim_treesitter ~= 1 then return end

require('nvim-treesitter.configs').setup{
  ensure_installed = "maintained",
  highlight = {
    enable = true,
    disable = { "rst" },
  },
  indent = {
    enable = true,
    disable = { "python" },
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
  },
  query_linter = {
    enable = true,
    use_virtual_text = true,
    lint_events = { "BufWrite", "CursorHold" },
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
