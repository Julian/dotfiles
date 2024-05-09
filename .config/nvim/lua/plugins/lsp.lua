local function peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, function(_, result, _)
    if result == nil or vim.tbl_isempty(result) then
      vim.notify('No definition found.')
      return nil
    end
    if vim.tbl_islist(result) then
      result = result[1]
    end
    vim.lsp.util.preview_location(result, { border = 'single' })
  end)
end

local function on_attach(client, bufnr)
  local function cmd(mode, lhs, rhs)
    vim.keymap.set(mode, lhs, rhs, { noremap = true, buffer = true })
  end

  vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

  cmd('n', 'gd', vim.lsp.buf.definition)
  cmd('n', 'gD', vim.lsp.buf.declaration)
  cmd('n', 'gi', vim.lsp.buf.implementation)
  cmd('n', 'gK', peek_definition)

  cmd('n', '<leader>R', vim.lsp.buf.rename)

  cmd('n', '<leader>La', vim.lsp.buf.add_workspace_folder)
  cmd('n', '<leader>Ld', vim.lsp.buf.remove_workspace_folder)
  cmd('n', '<leader>Ll', function() vim.print(vim.lsp.buf.list_workspace_folders()) end)
  cmd('n', '<leader>Lr', vim.lsp.buf.references)

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
    vim.cmd [[
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
    cmd('n', '<leader>a', require("actions-preview").code_actions)
    cmd('i', '<C-a>', require("actions-preview").code_actions)
  end

  if client.server_capabilities.codeLensProvider then
    cmd('n', '<leader>Le', vim.lsp.codelens.display)
    cmd('n', '<leader>Ln', vim.lsp.codelens.run)
    vim.cmd [[
      augroup lsp_codelens
        autocmd!
        autocmd BufEnter,CursorHold,InsertLeave <buffer> lua vim.lsp.codelens.refresh()
      augroup END
    ]]
  end

  if client.server_capabilities.inlayHintProvider then
    vim.cmd [[hi link LspInlayHint SpecialComment]]
    cmd('n', '<C-h>', function() vim.lsp.inlay_hint(bufnr, nil) end)
    cmd('i', '<C-h>', function() vim.lsp.inlay_hint(bufnr, nil) end)
  end
end

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

return {
  {
    'neovim/nvim-lspconfig',
    lazy = false,
    dependencies = { 'aznhe21/actions-preview.nvim' },
    config = function()
      local lspconfig = require('lspconfig')

      local opts = {
        on_attach = on_attach,
        capabilities = require 'cmp_nvim_lsp'.default_capabilities()
      }
      local lsps = {
        clangd = {},
        clojure_lsp = {},
        eslint = {},
        gopls = {},
        marksman = {},
        ruff_lsp = {},
        taplo = {},
        texlab = {},
        tsserver = {},
        vimls = {},

        jsonls = {
          json = {
            schemas = require('schemastore').json.schemas(),
            validate = { enable = true },
          },
        },

        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },

        esbonio = { cmd = { 'esbonio' } },

        pylsp = {
          settings = {
            pylsp = {
              plugins = {
                black = { enabled = true, line_length = 79 },

                ruff = { enabled = false },
                autopep8 = { enabled = false },
                flake8 = { enabled = false },
                mccabe = { enabled = false },
                pycodestyle = { enabled = false },
                pydocstyle = { enabled = false },
                pyflakes = { enabled = false },
                pylint = { enabled = false },
                yapf = { enabled = false },
              },
            },
          },
        },

        lua_ls = {
          on_init = function(client)
            local path = client.workspace_folders[1].name
            local luarc = path .. '/.luarc.json'
            if not vim.loop.fs_stat(luarc) and not vim.loop.fs_stat(luarc .. 'c') then
              client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                Lua = {
                  runtime = {
                    version = 'LuaJIT',
                    path = runtime_path,
                  },
                  completion = {
                    keywordSnippet = "Replace",
                    callSnippet = "Replace"
                  },
                  diagnostics = {
                    globals = { 'describe', 'it', 'pending', 'vim' },
                  },
                  hint = { enable = true },
                  workspace = {
                    checkThirdParty = "ApplyInMemory",
                    library = vim.api.nvim_get_runtime_file("", true),
                  },
                  telemetry = { enable = false },
                },
              })

              client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
            end
            return true
          end,
        },
      }

      for lsp, lsp_opts in pairs(lsps) do
        lspconfig[lsp].setup(vim.tbl_extend("force", opts, lsp_opts))
      end

      vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, { border = "single" })


      local lint = require('lint')

      lint.linters.mathlib4 = {
        name = 'mathlib',
        cmd = 'scripts/lint-style.py',
        stdin = false,
        stream = 'stdout',
        ignore_exitcode = true,
        parser = require('lint.parser').from_pattern(
          '::(%l+) file=([^:]+),line=(%d+),code=ERR_(%w+)::[^ ]+ ERR_%w+: (.+)',
          { 'severity', 'file', 'lnum', 'code', 'message' }
        ),
      }

      lint.linters_by_ft = {
        lean = { 'mathlib4' },
      }
    end,
  },
  {
    'Julian/lean.nvim',
    dev = true,
    dependencies = { 'nvim-lua/plenary.nvim' },
    event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
    config = function(_, opts)
      require('lean').setup(opts)
      vim.api.nvim_create_autocmd({ 'WinClosed', 'VimResized' }, {
        -- TODO: Only when Lean is started...
        callback = require('lean.infoview').reposition
      })
    end,
    opts = {
      infoview = {
        show_processing = false,
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
      lsp3 = {
        cmd = { 'lean-language-server', '--stdio', '--', '-M', '6144', '-T', '3000000' },
        on_attach = on_attach,
      },
      mappings = true,
      stderr = {
        on_lines = function(lines)
          vim.notify(
            lines,
            vim.log.levels.ERROR,
            { timeout = 3000, render = 'minimal' }
          )
        end,
      }
    }
  },
  {
    'mrcjkb/rustaceanvim',
    event = { 'BufReadPre *.rs', 'BufNewFile *.rs' },
    ft = { 'rust' },
    config = function(_, opts)
      vim.g.rustaceanvim = vim.tbl_deep_extend("force", {}, opts or {})
    end,
    opts = {
      server = {
        on_attach = on_attach,
        settings = {
          ["rust-analyzer"] = {
            cargo = { features = "all" },
            checkOnSave = true,
            check = { command = "clippy", features = "all" },
            procMacro = { enable = true },
          },
        }
      },
    },
  },
}
