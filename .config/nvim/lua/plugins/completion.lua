local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

return {
  {
    'hrsh7th/nvim-cmp',
    lazy = false,
    config = function()
      local cmp = require'cmp'

      cmp.setup{
        preselect = cmp.PreselectMode.None,
        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        mapping = {
          ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          ['<C-f>'] = cmp.mapping.scroll_docs(4),
          ['<CR>'] = cmp.mapping.confirm{ select = false },
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif vim.snippet.active{ direction = 1 } then
              vim.snippet.jump(1)
            elseif has_words_before() then
              cmp.complete()
            else
              fallback() -- <Tab>
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
              cmp.select_prev_item()
            elseif vim.snippet.active{ direction = -1 } then
              vim.snippet.jump(-1)
            end
          end, { "i", "s" }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'nvim_lsp_signature_help' },
          { name = 'path' },
          { name = 'lazydev', group_index = 0 },
          { name = 'buffer' },
        }
      }

      cmp.setup.filetype('gitcommit', {
        sources = cmp.config.sources({
          { name = 'git' },
        },
        { { name = 'buffer' }, })
      })

      vim.keymap.set('n', '<CR>', function()
        local filetype = vim.opt.filetype:get()
        if filetype == 'qf' or vim.fn.win_gettype() == 'command' then return '<CR>'
        elseif filetype == 'help' then return '<C-]>'
        elseif require('dap').session() ~= nil then require('dap').run_to_cursor() return ''
        else
          local obsidian = require'obsidian'.get_client()
          local vault = obsidian.dir.filename
          local target = vim.fs.joinpath(vault, 'Home.md')

          local workspace = vim.lsp.buf.list_workspace_folders()[1] or vim.uv.cwd()

          -- Look for an exact match, otherwise start stripping off
          -- any `.`'s until we find one.
          -- Really I'd like a way to find notes by Obsidian aliases?
          -- But I don't immediately see that in obsidian.nvim.
          local name = vim.fs.basename(workspace)

          local project_note = vim.fs.joinpath(vault, 'Projects', name .. '.md')
          if vim.uv.fs_stat(project_note) then
            target = project_note
          else
            local n
            name, n = name:gsub('%..*', '')
            project_note = vim.fs.joinpath(vault, 'Projects', name .. '.md')
            if n > 0 and vim.uv.fs_stat(project_note) then
              target = project_note
            end
          end

          _G.split(target)
          return ''
        end
      end, { expr = true })

      vim.cmd[[
      highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
      highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
      highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
      highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
      highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
      highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
      ]]
    end,
    dependencies = {
      { 'hrsh7th/cmp-buffer' },
      { 'hrsh7th/cmp-nvim-lsp' },
      { 'hrsh7th/cmp-nvim-lsp-document-symbol' },
      { 'hrsh7th/cmp-nvim-lsp-signature-help' },
      { 'hrsh7th/cmp-path' },
      {
        'petertriho/cmp-git',
        opts = {},
        dependencies = { 'nvim-lua/plenary.nvim' },
      },
    }
  },
}
