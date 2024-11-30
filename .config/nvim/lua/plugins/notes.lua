local VAULT = vim.fs.joinpath(vim.env.XDG_DOCUMENTS_DIR, 'Obsidian')

return {
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    ft = 'markdown',
    keys = {
      {
        '<leader><CR>',
        '<Cmd>ObsidianQuickSwitch<CR>',
        desc = 'Switch to another file in the vault.',
      },
      {
        '†',
        '<Cmd>ObsidianToday<CR>',
        desc = "Go to today's note.",
      },
      {
        '<M-t>',
        '<Cmd>ObsidianToday<CR>',
        desc = "Go to today's note.",
      },
      {
        '<M-CR>',
        function()
          require('telescope.builtin').live_grep{ search_dirs = { VAULT } }
        end,
        desc = 'Live grep the vault.',
      },
    },
    cmd = {
      'ObsidianOpen',
      'ObsidianNew',
      'ObsidianQuickSwitch',
      'ObsidianFollowLink',
      'ObsidianBacklinks',
      'ObsidianTags',
      'ObsidianToday',
      'ObsidianYesterday',
      'ObsidianTomorrow',
      'ObsidianDailies',
      'ObsidianTemplate',
      'ObsidianSearch',
      'ObsidianLink',
      'ObsidianLinkNew',
      'ObsidianLinks',
      'ObsidianExtractNote',
      'ObsidianWorkspace',
      'ObsidianPasteImg',
      'ObsidianRename',
      'ObsidianToggleCheckbox',
      'ObsidianNewFromTemplate',
      'ObsidianTOC',
    },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      workspaces = { { name = 'vault', path = VAULT } },
      callbacks = {
        enter_note = function()
          local note_window = vim.api.nvim_get_current_win()

          vim.cmd.Vista()
          vim.api.nvim_create_autocmd('BufEnter', {
            buffer = 0,
            callback = function()
              local nonfloating = vim.iter(vim.api.nvim_tabpage_list_wins(0)):filter(function(window)
                return vim.api.nvim_win_get_config(window).relative ~= ''
              end):totable()
              if #nonfloating == 1 then
                vim.cmd.quit()
              end
            end
          })

          vim.api.nvim_set_current_win(note_window)

          vim.keymap.set('n', '<leader><leader>t', vim.cmd.ObsidianTOC, { buffer = true })
          vim.keymap.set('n', '<leader><leader>u', vim.cmd.ObsidianLinks, { buffer = true })
        end,
      },
      follow_url_func = vim.ui.open,
    },
  },
}
