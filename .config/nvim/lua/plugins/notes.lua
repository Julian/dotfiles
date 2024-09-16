local VAULT = vim.fs.joinpath(vim.env.XDG_DOCUMENTS_DIR, 'Obsidian')

return {
  {
    'epwalsh/obsidian.nvim',
    version = '*',
    ft = 'markdown',
    keys = {
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
      workspaces = {
        { name = 'vault', path = VAULT },
      },
      follow_url_func = vim.ui.open,
    },
  },
}
