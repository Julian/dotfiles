return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = { 'nvim-telescope/telescope-ui-select.nvim' },
    config = function(_, opts)
      require('telescope').setup(opts)
      require('telescope').load_extension('ui-select')
    end,
    opts = function(_)
      return {
        defaults = {
          layout_config = {
            prompt_position = 'top',
          },
          sorting_strategy = 'ascending',
          mappings = {
            i = {
              ['<esc>'] = require('telescope.actions').close,
            },
          },
        },
        extensions = {
          ['ui-select'] = { require('telescope.themes').get_dropdown{} }
        },
      }
    end,
  }
}
