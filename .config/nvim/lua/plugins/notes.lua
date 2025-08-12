local VAULT = vim.env.OBSIDIAN_VAULT

local function Obsidian(command)
  return function() vim.cmd.Obsidian(command) end
end

return {
  {
    'obsidian-nvim/obsidian.nvim',
    version = '*',
    ft = 'markdown',
    keys = {
      {
        '<leader><CR>',
        Obsidian 'quick_switch',
        desc = 'Switch to another file in the vault.',
      },
      {
        '<LocalLeader>e',
        Obsidian 'extract_note',
        mode = 'v',
        desc = 'Extract the visual selection to a new note.',
      },
      {
        '†',
        Obsidian 'today',
        desc = "Go to today's note.",
      },
      {
        '<M-t>',
        Obsidian 'today',
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
    cmd = { 'Obsidian' },
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      workspaces = {
        { name = 'vault', path = VAULT },
        vim.env.OBSIDIAN_WORK_VAULT and { name = 'work', path = vim.env.OBSIDIAN_WORK_VAULT } or nil,
      },
      templates = { folder = 'templates' },
      disable_frontmatter = true, -- constantly breaks things...
      legacy_commands = false,
      callbacks = {
        enter_note = function()
          local note_window = vim.api.nvim_get_current_win()

          vim.wo.spell = true

          vim.cmd.Vista()
          vim.api.nvim_create_autocmd('BufEnter', {
            buffer = 0,
            callback = function()
              local nonfloating = vim.iter(vim.api.nvim_tabpage_list_wins(0)):filter(function(window)
                -- TODO: Maybe this actually should filter on "is any other
                --       vault note open" and close even if other windows are
                --       open that aren't from the vault.
                return vim.api.nvim_win_get_config(window).relative == ''
              end):totable()
              if #nonfloating == 1 then
                vim.cmd.quit()
              end
            end
          })

          vim.api.nvim_set_current_win(note_window)

          vim.keymap.set('n', '<localleader>b', Obsidian 'backlinks', { buffer = true })
          vim.keymap.set('n', '<localleader>l', Obsidian 'links', { buffer = true })
          vim.keymap.set('n', '<localleader>t', Obsidian 'toc', { buffer = true })
        end,
      },
      follow_url_func = vim.ui.open,
    },
  },
}
