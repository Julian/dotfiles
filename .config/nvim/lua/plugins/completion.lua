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
        local open_wiki = ':<C-U>VimwikiIndex<CR>'

        local filetype = vim.opt.filetype:get()
        local dap = require('dap')
        if filetype == 'qf' or vim.fn.win_gettype() == 'command' then return '<CR>'
        elseif filetype == 'help' then return '<C-]>'
        elseif filetype == 'vimwiki' then return ':VimwikiFollowLink<CR>'
        elseif dap.session() ~= nil then dap.run_to_cursor() return ''
        elseif vim.api.nvim_buf_get_name(0):match("TODO") then return open_wiki
        else
          local split = ':<C-U>SplitSensibly '
          local todo = vim.fn.glob('TODO*', true, true)[1]
          if todo then
            return split .. todo .. '<CR>'
          else
            return split .. '<CR>' .. open_wiki
          end
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
