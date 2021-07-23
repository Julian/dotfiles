local telescope = require('telescope')
local actions = require('telescope.actions')
local builtin = require('telescope.builtin')

function find_symbols()
  if vim.tbl_isempty(vim.fn.tagfiles()) then
    builtin.lsp_document_symbols()
  else
    builtin.tags()
  end
end

function find_symbols_from_buffer()
  builtin.current_buffer_tags()
end

telescope.setup{
  defaults = {
    layout_config = {
      prompt_position = "top",
    },
    sorting_strategy = "ascending",
    mappings = {
      i = {
        ["<esc>"] = actions.close
      },
    },
  }
}
