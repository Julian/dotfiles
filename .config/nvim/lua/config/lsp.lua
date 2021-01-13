local completion = require('completion')
local lspconfig = require('lspconfig')

local function cmd(mode, key, cmd)
  vim.api.nvim_buf_set_keymap(
    0, mode, key, '<cmd>lua ' .. cmd .. '<CR>', {noremap = true}
  )
end

function maybe_hover()
  if not vim.tbl_isempty(vim.lsp.diagnostic.get_line_diagnostics()) then
    vim.lsp.diagnostic.show_line_diagnostics()
  elseif vim.lsp.buf_get_clients()[1].resolved_capabilities.hover then
    vim.lsp.buf.hover()
  end
end

local function attached(client)
  cmd('n', 'K', 'maybe_hover()')
  cmd('n', 'gd', 'vim.lsp.buf.definition()')
  cmd('n', 'gi', 'vim.lsp.buf.implementation()')
  cmd('n', 'gr', 'vim.lsp.buf.references()')
  cmd('n', 'gy', 'vim.lsp.buf.type_definition()')
  cmd('n', '<C-]>', 'vim.lsp.buf.definition()')
  vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
  completion.on_attach(client)
end

local opts = {on_attach = attached}
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

return {attached = attached}
