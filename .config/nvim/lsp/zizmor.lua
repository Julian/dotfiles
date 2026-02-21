---@type vim.lsp.Config
return {
  cmd = { 'uvx', 'zizmor', '--lsp' },
  filetypes = { 'yaml' },
  single_file_support = false,
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if not fname:match('/%.github/workflows/.*%.ya?ml$') then
      return
    end

    local git_root = vim.fs.find('.git', { path = fname, upward = true })[1]
    if git_root then
      on_dir(vim.fs.dirname(git_root))
    else
      on_dir(vim.fs.dirname(fname))
    end
  end,
}
