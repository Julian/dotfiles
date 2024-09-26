local VAULT = vim.fs.joinpath(vim.env.XDG_DOCUMENTS_DIR, 'Obsidian')

return {
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = { 'markdown', 'latex' },
    cmd = { 'RenderMarkdown' },
    opts = {},
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
  },
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
      ui = { enable = false }, -- let render-markdown do its thing
      workspaces = {
        { name = 'vault', path = VAULT },
      },
      follow_url_func = vim.ui.open,
    },
  },
}
