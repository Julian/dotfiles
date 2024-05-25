return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope-ui-select.nvim',
    },
    cmd = { 'Telescope' },
    init = function()
      vim.ui.select = function(...)
        -- Trigger telescope-ui-select to load
        require('telescope')
        return vim.ui.select(...)
      end
    end,
    config = function(_, opts)
      local telescope = require('telescope')
      telescope.setup(opts)
      telescope.load_extension('ui-select')
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
