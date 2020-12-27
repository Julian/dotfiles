local completion = require('completion')
local snippets = require('snippets')

vim.g.completion_matching_strategy_list = {'exact', 'substring', 'fuzzy'}

-- Expand a snippet if it exactly matches, otherwise complete.
function tab()
  local _, expanded = snippets.lookup_snippet_at_cursor()
  if expanded ~= nil then
    snippets.expand_at_cursor()
    return
  end
  completion.smart_tab()
end

vim.api.nvim_set_keymap('i', '<Tab>', '<Cmd>lua tab()<CR>', {})
vim.api.nvim_set_keymap('i', '<S-Tab>', '<Plug>(completion_smart_s_tab)', {})
