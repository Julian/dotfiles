local orgmode = require('orgmode')
local ORG_HOME = vim.fn.expand('$XDG_DATA_HOME/org')
orgmode.setup_ts_grammar()
orgmode.setup{
  mappings = { prefix = '<LocalLeader>' },
  org_agenda_files = { ORG_HOME .. '/**' },
  org_default_notes_file = ORG_HOME .. '/refile.org',
}
