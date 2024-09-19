local function peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/definition', params, function(_, result, _)
    if result == nil or vim.tbl_isempty(result) then
      vim.notify('No definition found.')
      return nil
    end
    if vim.islist(result) then
      result = result[1]
    end
    vim.lsp.util.preview_location(result, { border = 'single' })
  end)
end

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    local opts = { noremap = true, buffer = bufnr }

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gb', vim.lsp.buf.implementation, opts)
    vim.keymap.set('n', 'gK', peek_definition, opts)

    if client.supports_method('textDocument/rename') then
      vim.keymap.set('n', '<leader>R', vim.lsp.buf.rename, opts)
    end

    vim.keymap.set('n', '<leader>La', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>Ld', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>Ll', function() vim.print(vim.lsp.buf.list_workspace_folders()) end, opts)

    if client.supports_method('textDocument/formatting') then
      vim.keymap.set('n', '<leader>z', vim.lsp.buf.format, opts)
    end

    if client.supports_method('textDocument/typeDefinition') then
      vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
    end

    if client.supports_method('textDocument/signatureHelp') then
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, opts)
    end

    if client.supports_method('textDocument/documentHighlight') then
      vim.cmd [[
        :hi LspReferenceRead cterm=reverse gui=reverse
        :hi LspReferenceWrite guifg=#223249 guibg=#ff9e3b
        :hi LspReferenceText cterm=bold gui=bold
        augroup lsp_document_highlight
          autocmd!
          autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
      ]]
    end

    if client.supports_method('textDocument/codeAction') then
      vim.keymap.set('n', '<leader>a', require("actions-preview").code_actions, opts)
      vim.keymap.set('i', '<C-a>', require("actions-preview").code_actions, opts)
    end

    if client.supports_method('textDocument/codeLens') then
      vim.keymap.set('n', '<leader>Le', vim.lsp.codelens.display, opts)
      vim.keymap.set('n', '<leader>Ln', vim.lsp.codelens.run, opts)
      vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
        buffer = bufnr,
        callback = function() vim.lsp.codelens.refresh{ bufnr = bufnr } end,
      })
    end

    if client.supports_method('textDocument/inlayHint') then
      vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

      -- vim.cmd [[hi link LspInlayHint SpecialComment]]
      vim.keymap.set({ 'n', 'i' }, '<C-h>', function()
        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled{ bufnr = bufnr }, { bufnr = bufnr })
      end, opts)
    end
  end
})

local runtime_path = vim.split(package.path, ';')
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { 'LspInfo', 'LspInstall', 'LspUninstall' },
    dependencies = { 'aznhe21/actions-preview.nvim' },
    config = function()
      local lspconfig = require('lspconfig')

      local opts = {
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
        ts_ls = {},
        typst_lsp = {},
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
            -- this is a neovim bug seemingly
            -- (e.g. see prior precedent in neovim/nvim-lspconfig#1471)
            if not client.workspace_folders then return end
            local path = client.workspace_folders[1].name
            local luarc = path .. '/.luarc.json'
            if vim.loop.fs_stat(luarc) or vim.loop.fs_stat(luarc .. 'c') then
              return
            end
            client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
              runtime = {
                version = 'LuaJIT',
                path = runtime_path,
              },
              completion = {
                callSnippet = 'Both',
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
            })

            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
          end,
          settings = { Lua = {} },
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
    'folke/lazydev.nvim',
    ft = 'lua',
    opts = {
      library = {
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
        { path = "luassert-types/library", words = { 'assert' } },
        { path = "busted-types/library", words = { 'describe' } },
      },
    },
  },
  { 'Bilal2453/luvit-meta' },
  { 'LuaCATS/luassert', name = 'luassert-types' },
  { 'LuaCATS/busted', name = 'busted-types' },
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
            if name ~= "" and not name:match('.*%.lean') then return false end
          end
          return true
        end
      },
      mappings = true,
      stderr = {
        on_lines = function(lines)
          local opts = {
            timeout = 3000,
            render = 'minimal',
          }

          local _, _, maybe_level, rest = lines:find('^(%w+): (.*)')
          local level = vim.log.levels[maybe_level:upper()]
          if not level then
            rest = lines
          end
          vim.notify(rest, level, opts)
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
