---@param client vim.lsp.Client
---@param method string
local function peek(client, method)
  return function()
    local params = vim.lsp.util.make_position_params(0, client.offset_encoding)
    return client:request(method, params, function(err, result, _)
      if err then
        vim.notify(err.message, vim.log.levels.ERROR)
        return
      end
      if result == nil or vim.tbl_isempty(result) then
        vim.notify('No definition found.')
        return nil
      end
      if vim.islist(result) then
        result = result[1]
      end
      vim.lsp.util.preview_location(result)
    end)
  end
end

local hl_augroup = vim.api.nvim_create_augroup('LspAutocmds', {})

vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local bufnr = args.buf
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then return end

    local opts = { noremap = true, buffer = bufnr }

    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gK', peek(client, vim.lsp.protocol.Methods.textDocument_definition), opts)
    vim.keymap.set('n', 'gL', peek(client, vim.lsp.protocol.Methods.textDocument_declaration), opts)

    vim.keymap.set('n', '<leader>La', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>Ld', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>Ll', function() vim.print(vim.lsp.buf.list_workspace_folders()) end, opts)

    -- grn: rename()
    -- grr: references()
    -- gri: implementation()
    -- gO: document_symbol()

    if client:supports_method('textDocument/formatting') then
      vim.keymap.set('n', '<leader>z', vim.lsp.buf.format, opts)
    end

    if client:supports_method('textDocument/typeDefinition') then
      vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
    end

    if client:supports_method('textDocument/signatureHelp') then
      vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
      vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, opts)
    end


    vim.api.nvim_clear_autocmds({ group = hl_augroup, buffer = bufnr })
    if client:supports_method('textDocument/documentHighlight') then
      vim.cmd [[
        :hi LspReferenceRead cterm=reverse gui=reverse
        :hi LspReferenceWrite guifg=#223249 guibg=#ff9e3b
        :hi LspReferenceText cterm=bold gui=bold
      ]]
      vim.api.nvim_create_autocmd('CursorHold', {
        callback = vim.lsp.buf.document_highlight,
        buffer = bufnr,
        group = hl_augroup,
        desc = 'Show document highlight on cursor hold.',
      })
      vim.api.nvim_create_autocmd('CursorMoved', {
        callback = vim.lsp.buf.clear_references,
        buffer = bufnr,
        group = hl_augroup,
        desc = 'Clear highlights when the cursor moves.',
      })
    end

    if client:supports_method('textDocument/codeAction') then
      vim.keymap.set('n', '<leader>a', require("actions-preview").code_actions, opts)
      vim.keymap.set('i', '<C-a>', require("actions-preview").code_actions, opts)
    end

    if client:supports_method('textDocument/codeLens') then
      vim.keymap.set('n', '<leader>Le', vim.lsp.codelens.display, opts)
      vim.keymap.set('n', '<leader>Ln', vim.lsp.codelens.run, opts)
      vim.api.nvim_create_autocmd({ 'BufEnter', 'CursorHold', 'InsertLeave' }, {
        callback = function() vim.lsp.codelens.refresh{ bufnr = bufnr } end,
        group = hl_augroup,
        buffer = bufnr,
      })
    end

    if client:supports_method('textDocument/inlayHint') then
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

vim.lsp.config('beancount', {
  init_options = {
    journal_file = {
      vim.fs.joinpath(vim.env.OBSIDIAN_VAULT, 'ledger.beancount'),
    },
  },
})
vim.lsp.config('esbonio', {
  cmd = { 'esbonio' },
})
vim.lsp.config('jsonls', {
  json = {
    schemas = require('schemastore').json.schemas(),
    validate = { enable = true },
  },
})
vim.lsp.config('yamlls', {
  settings = {
    yaml = {
      keyOrdering = false,
    },
  },
})

vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      telemetry = { enable = false },
      completion = {
        callSnippet = 'Both',
      },
      hint = {
        enable = true,
        setType = true,
      },
    },
  },
})

vim.lsp.config('ty', {
  settings = {
    ty = {
    },
  },
})

vim.lsp.enable {
  'beancount',
  'clangd',
  'clojure_lsp',
  'eslint',
  'gopls',
  'jsonls',
  'lua_ls',
  'marksman',
  'ruff',
  'sourcekit',
  'taplo',
  'texlab',
  'tinymist',
  'ts_ls',
  'ty',
  'vimls',
  'yamlls',
}

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

return {
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { 'LspInfo', 'LspInstall', 'LspUninstall' },
    dependencies = { 'aznhe21/actions-preview.nvim' },
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
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    event = { 'BufReadPre *.lean', 'BufNewFile *.lean' },
    config = function(_, opts)
      vim.g.lean_config = opts
      require('lean').setup(opts)
      vim.api.nvim_create_autocmd({ 'WinClosed', 'VimResized' }, {
        -- TODO: Only when Lean is started...
        callback = require('lean.infoview').reposition
      })
    end,
    ---@type lean.Config
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

      log = function(level, data)
        if level < vim.log.levels.INFO then
          return
        end
        local message = (data.message or ''):match('^[^\n]*')
        ---@diagnostic disable-next-line: unused-local
        local _ = { newline = ' ', indent = '\n' }
        vim.notify( -- TODO: somehow we should use `replace`
          vim.inspect(data),
          level,
          {
            title = message or 'lean.nvim',
            render = 'wrapped-compact',
          }
        )
      end,

      mappings = true,
      stderr = {
        on_lines = function(lines)
          local opts = {
            timeout = 3000,
            render = 'wrapped-compact',
          }

          local _, _, maybe_level, rest = lines:find('^(%w+): (.*)')
          -- Lean uses warning rather than warn...
          -- and some message don't have any level...
          -- surely there's another way we should do this.
          local level = vim.log.levels[(maybe_level or ''):upper()]
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
