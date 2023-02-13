local lspconfig = require('lspconfig')
local notify = require('notify')

local function preview_location_callback(_, result, _)
  if result == nil or vim.tbl_isempty(result) then
    vim.notify('No definition found.')
    return nil
  end
  if vim.tbl_islist(result) then
    vim.lsp.util.preview_location(result[1])
  else
    vim.lsp.util.preview_location(result)
  end
end

local function peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, preview_location_callback)
end

local function on_attach(client, bufnr)
  local function cmd(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { noremap = true, buffer = true })
  end

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  cmd('n', 'gd', vim.lsp.buf.definition)
  cmd('n', 'gD', vim.lsp.buf.declaration)
  cmd('n', 'gK', peek_definition)
  cmd('n', '<leader>Li', vim.lsp.buf.implementation)
  cmd('n', '<leader>Lr', vim.lsp.buf.references)

  cmd('n', '<leader>n', function() vim.diagnostic.goto_next{float = { header = false }} end)
  cmd('n', '<leader>q', vim.diagnostic.setloclist)
  cmd('n', '<leader>r', vim.lsp.buf.rename)
  cmd('n', '<leader>K', function() vim.diagnostic.open_float(0, { scope = "line", header = false, focus = false }) end)
  cmd('n', '<leader>N', function() vim.diagnostic.goto_prev{float = { header = false }} end)

  cmd('n', '<leader>La', vim.lsp.buf.add_workspace_folder)
  cmd('n', '<leader>Ld', vim.lsp.buf.remove_workspace_folder)
  cmd('n', '<leader>Ll', function() vim.pretty_print(vim.lsp.buf.list_workspace_folders()) end)

  if client.server_capabilities.hoverProvider then
    cmd('n', 'K', vim.lsp.buf.hover)
  end

  if client.server_capabilities.documentFormattingProvider then
    cmd('n', '<leader>z', vim.lsp.buf.format)
  end

  if client.server_capabilities.typeDefinitionProvider then
    cmd('n', 'gy', vim.lsp.buf.type_definition)
  end

  if client.server_capabilities.signatureHelpProvider then
    cmd('n', '<C-k>', vim.lsp.buf.signature_help)
    cmd('i', '<C-s>', vim.lsp.buf.signature_help)
  end

  if client.server_capabilities.documentHighlightProvider then
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

  if client.server_capabilities.codeActionProvider then
    cmd('n', '<leader>a', vim.lsp.buf.code_action)
  end

  if client.server_capabilities.codeLensProvider then
    cmd('n', '<leader>Le', vim.lsp.codelens.display)
    cmd('n', '<leader>Ln', vim.lsp.codelens.run)

    vim.cmd[[
      augroup lsp_codelens
        autocmd!
        autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
      augroup END
    ]]
  end

  local semanticTokensProvider = client.server_capabilities.semanticTokensProvider
  if semanticTokensProvider and semanticTokensProvider.full then
    local augroup = vim.api.nvim_create_augroup("SemanticTokens", {})
    vim.api.nvim_create_autocmd("TextChanged", {
      group = augroup,
      buffer = bufnr,
      callback = function()
        vim.lsp.buf.semantic_tokens_full()
      end,
    })
    -- fire it first time on load as well
    vim.lsp.buf.semantic_tokens_full()
  end
end

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

local opts = {
  on_attach = on_attach,
  capabilities = require'cmp_nvim_lsp'.default_capabilities()
}
local lsps = {
  clangd = {},
  clojure_lsp = {},
  rust_analyzer = {},
  tailwindcss = {},
  taplo = {},
  texlab = {},
  tsserver = {},
  vimls = {},
  yamlls = {},

  jsonls = {
    json = {
      schemas = require('schemastore').json.schemas(),
      validate = { enable = true },
    },
  },

  esbonio = { cmd = { 'esbonio' } },

  pylsp = {
    plugins = {
      black = {
        enabled = true,
        line_length = 79,
      }
    }
  },

  lua_ls = {
    cmd = { "lua-language-server" },
    settings = {
      Lua = {
        runtime = {
          version = 'LuaJIT',
          path = runtime_path,
        },
        completion= {
          keywordSnippet="Replace",
          callSnippet="Replace"
        },
        diagnostics = {
          globals = { 'describe', 'it', 'pending', 'vim' },
        },
        workspace = { library = vim.api.nvim_get_runtime_file("", true) },
        telemetry = { enable = false },
      },
    },
  },
}

for lsp, lsp_opts in pairs(lsps) do
  lspconfig[lsp].setup(vim.tbl_extend("force", opts, lsp_opts))
end

vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })

require('lean').setup{
  infoview = {
    horizontal_position = 'top',
    autoopen = function()
      for _, window in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
        local buf = vim.api.nvim_win_get_buf(window)
        local name = vim.api.nvim_buf_get_name(buf)
        if not name:match('.*%.lean') then return false end
      end
      return true
    end
  },
  lsp = { on_attach = on_attach },
  lsp3 = { on_attach = on_attach },
  mappings = true,
  stderr = {
    on_lines = function(lines)
      notify(lines, 'error', { timeout = 3000, render = 'minimal' })
    end,
  }
}
vim.api.nvim_create_autocmd({ 'WinClosed', 'VimResized' }, {
  callback = require('lean.infoview').reposition
})

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

require("nvim-semantic-tokens").setup {
  preset = "default",
  highlighters = { require 'nvim-semantic-tokens.table-highlighter' },
}
