local completion = require('completion')
local lspconfig = require('lspconfig')


function maybe_hover()
  if not vim.tbl_isempty(vim.lsp.diagnostic.get_line_diagnostics()) then
    vim.lsp.diagnostic.show_line_diagnostics()
  else
    local clients = vim.tbl_values(vim.lsp.buf_get_clients())
    if not vim.tbl_isempty(clients)
       and clients[1].resolved_capabilities.hover then
       vim.lsp.buf.hover()
    end
  end
end

local function on_attach(client, bufnr)
  local function cmd(mode, key, cmd)
    vim.api.nvim_buf_set_keymap(
      bufnr,
      mode,
      key,
      '<cmd>lua ' .. cmd .. '<CR>',
      {noremap = true}
    )
  end

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  completion.on_attach(client, bufnr)

  cmd('n', 'K', 'maybe_hover()')
  cmd('n', 'gd', 'vim.lsp.buf.definition()')
  cmd('n', 'gD', 'vim.lsp.buf.declaration()')
  cmd('n', 'gi', 'vim.lsp.buf.implementation()')
  cmd('n', 'gr', 'vim.lsp.buf.references()')

  cmd('n', '<leader>n', 'vim.lsp.diagnostic.goto_next()')
  cmd('n', '<leader>q', 'vim.lsp.diagnostic.set_loclist()')
  cmd('n', '<leader>r', 'vim.lsp.buf.rename()')
  cmd('n', '<leader>K', 'vim.lsp.diagnostic.show_line_diagnostics()')
  cmd('n', '<leader>N', 'vim.lsp.diagnostic.goto_prev()')

  cmd('n', '<leader>Fa', 'vim.lsp.buf.add_workspace_folder()')
  cmd('n', '<leader>Fr', 'vim.lsp.buf.remove_workspace_folder()')
  cmd('n', '<leader>Fl', 'print(vim.inspect(vim.lsp.buf.list_workspace_folders()))')

  if client.resolved_capabilities.document_formatting then
    cmd('n', '<leader>z', 'vim.lsp.buf.formatting()')
  end

  if client.resolved_capabilities.type_definition then
    cmd('n', 'gy', 'vim.lsp.buf.type_definition()')
  end

  if client.resolved_capabilities.signature_help then
    cmd('n', '<C-k>', 'vim.lsp.buf.signature_help()')
  end

  if client.resolved_capabilities.document_highlight then
    vim.api.nvim_exec([[
      :hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      :hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      :hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]], false)
  end
end

local opts = {on_attach = on_attach}
local lsps = {
  pyls = {},
  sumneko_lua = {
    Lua = {
      runtime = {
        version = 'LuaJIT',
        path = vim.split(package.path, ';'),
      },
      diagnostics = {
        globals = {'vim'},
      },
      workspace = {
        library = {
          [vim.fn.expand('$VIMRUNTIME/lua')] = true,
          [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
        },
      },
    },
  },
  tsserver = {},
  vimls = {},
}

for lsp, lsp_opts in pairs(lsps) do
  lspconfig[lsp].setup(vim.tbl_extend("force", opts, lsp_opts))
end

return {on_attach = on_attach}
