local telescope = require('telescope')
local actions = require('telescope.actions')

telescope.setup{
  defaults = {
    layout_config = {
      prompt_position = 'top',
    },
    sorting_strategy = 'ascending',
    mappings = {
      i = {
        ['<esc>'] = actions.close
      },
    },
  },
  extensions = {
    ["ui-select"] = { require("telescope.themes").get_dropdown{} }
  },
}
telescope.load_extension('ui-select')
