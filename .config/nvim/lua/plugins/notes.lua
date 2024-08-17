return {
  {
    'vimwiki/vimwiki',
    branch = 'dev',
    cmd = 'VimwikiIndex',
    init = function()
      vim.g.vimwiki_key_mappings = { all_maps = 0 }
      vim.g.vimwiki_list = {
        {
          path = vim.env.XDG_DATA_HOME .. '/nvim/',
          index = 'global',
        },
      }
    end,
  },
}
