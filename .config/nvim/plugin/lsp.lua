local lspconfig = require('lspconfig')

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

  cmd('n', 'gd', 'vim.lsp.buf.definition()')
  cmd('n', 'gD', 'vim.lsp.buf.declaration()')
  cmd('n', '<leader>Li', 'vim.lsp.buf.implementation()')
  cmd('n', '<leader>Lr', 'vim.lsp.buf.references()')

  cmd('n', '<leader>n', 'vim.diagnostic.goto_next{float = { show_header = false }}')
  cmd('n', '<leader>q', 'vim.diagnostic.setloclist()')
  cmd('n', '<leader>r', 'vim.lsp.buf.rename()')
  cmd('n', '<leader>K', 'vim.diagnostic.open_float(0, { scope = "line", show_header = false })')
  cmd('n', '<leader>N', 'vim.diagnostic.goto_prev{float = { show_header = false }}')

  cmd('n', '<leader>La', 'vim.lsp.buf.add_workspace_folder()')
  cmd('n', '<leader>Ld', 'vim.lsp.buf.remove_workspace_folder()')
  cmd('n', '<leader>Ll', 'print(vim.inspect(vim.lsp.buf.list_workspace_folders()))')

  if client.resolved_capabilities.hover then
    cmd('n', 'K', 'vim.lsp.buf.hover()')
  end

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
    vim.cmd[[
      :hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
      :hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
      :hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
      augroup lsp_document_highlight
        autocmd!
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
      augroup END
    ]]
  end

  if client.resolved_capabilities.code_action then
    cmd('n', '<leader>a', 'vim.lsp.buf.code_action()')
  end

  if client.resolved_capabilities.code_lens then
    cmd('n', '<leader>Le', 'vim.lsp.codelens.display()')
    cmd('n', '<leader>Ln', 'vim.lsp.codelens.run()')

    vim.cmd[[
      augroup lsp_codelens
        autocmd!
        autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
      augroup END
    ]]
  end
end

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local opts = {
  on_attach = on_attach,
  capabilities = require'cmp_nvim_lsp'.update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  )
}
local lsps = {
  ccls = {
    init_options = {
        compilationDatabaseDirectory = "build",
      },
  },
  sumneko_lua = {
    cmd = { "lua-language-server" },
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = runtime_path,
        },
        diagnostics = {
          globals = { 'describe', 'it', 'pending', 'vim' },
        },
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        telemetry = { enable = false },
      },
    },
  },
  pylsp = {},
  tsserver = {},
  vimls = {},
}

for lsp, lsp_opts in pairs(lsps) do
  lspconfig[lsp].setup(vim.tbl_extend("force", opts, lsp_opts))
end

require('lean').setup{
  abbreviations = { builtin = true },
  lsp = { on_attach = on_attach },
  lsp3 = { on_attach = on_attach },
  mappings = true,
}

local lint = require('lint')

lint.linters.mathlib = {
  cmd = 'scripts/lint-style.py',
  stdin = true,
  args = {'/dev/stdin'},
  stream = 'stdout',
  ignore_exitcode = true,
  parser = require('lint.parser').from_errorformat('::%trror file=%f\\,line=%l\\,code=ERR_%[A-Z]%\\+::ERR_%[A-Z]\\*:%m'),
}

lint.linters_by_ft = {
  lean3 = { 'mathlib' };
  python = { 'flake8' };
}
