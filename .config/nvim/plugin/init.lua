function _G.q(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
  return ...
end

function _G.t(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

--- Jump to the next entry in the jumplist which is a child of the current working directory.
function _G.jump_to_last_in_project()
  local cwd = vim.fn.getcwd()
  local jumplist, current = unpack(vim.fn.getjumplist())
  for position = current - 1, 1, -1 do
    local jump = jumplist[position]
    local path = vim.api.nvim_buf_get_name(jump.bufnr)
    if vim.startswith(path, cwd) then
      return vim.api.nvim_win_set_buf(0, jump.bufnr)
    end
  end
end

--- Jump to the last entry in the jumplist which is a child of the current working directory.
function _G.jump_to_next_in_project()
  local cwd = vim.fn.getcwd()
  local jumplist, current = unpack(vim.fn.getjumplist())
  for position = current, #jumplist, 1 do
    local jump = jumplist[position]
    local path = vim.api.nvim_buf_get_name(jump.bufnr)
    if vim.startswith(path, cwd) then
      return vim.api.nvim_win_set_buf(0, jump.bufnr)
    end
  end
end

vim.diagnostic.config({ severity_sort = true })

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
