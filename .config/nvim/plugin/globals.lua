local statfs = vim.loop.fs_statfs(vim.fn.expand("$MYVIMRC"))  -- < 5GB left
_G.SMALL_FILESYSTEM = (statfs.bavail * statfs.bsize) < 5 * 1024 * 1024 * 1024

function _G.q(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
  return ...
end
vim.cmd[[command! -nargs=1 -complete=lua Q lua q(<args>)]]

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

--- The parent dir of the current buffer if it has a name, otherwise cwd.
function _G.parent_or_cwd()
  local name = vim.fn.expand('%:h')
  if name == "" then return vim.fn.getcwd() end
  return name
end
