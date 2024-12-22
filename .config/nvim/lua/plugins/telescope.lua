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
      telescope.load_extension('notify')
      telescope.load_extension('ui-select')
    end,
    opts = function(_)
      local actions = require('telescope.actions')
      return {
        defaults = {
          layout_config = {
            prompt_position = 'top',
          },
          sorting_strategy = 'ascending',
          mappings = {
            i = {
              ['<C-Q>'] = actions.smart_send_to_qflist + actions.open_qflist,
              ['<Esc>'] = actions.close,
              ['<C-CR>'] = actions.to_fuzzy_refine,
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
