return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
      filetypes = {
        lean = true,
        lua = true,
        ['*'] = false,
      },
      suggestion = { enabled = false },
      panel = { enabled = false },
      server_opts_overrides = {
        settings = {
          telemetry = { telemetryLevel = 'off' },
        },
      },
    },
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    build = 'make tiktoken',
    opts = {
      chat_autocomplete = false,
      window = {
        width = 60,
      },
      mappings = {
        complete = { normal = '', insert = '' },
        close = { normal = '', insert = '' },
        reset = { normal = '<C-l>', insert = false },
        submit_prompt = {},
        toggle_sticky = {},
        clear_stickies = {},
        accept_diff = {},
        jump_to_diff = { normal = ']c', insert = false },
        quickfix_answers = {},
        quickfix_diffs = {},
        yank_diff = {},
        show_diff = {},
        show_info = {},
        show_context = {},
        show_help = { normal = '<localleader>/' },
      }
    },
    keys = {
      {
        '<leader>c',
        function()
          local windows = vim.api.nvim_list_wins()
          local bufnr = vim.api.nvim_win_get_buf(windows[1])
          if #windows == 1
            and vim.api.nvim_buf_get_name(bufnr) == ''
            and vim.api.nvim_buf_line_count(bufnr) == 1
            and vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)[1] == '' then
              vim.cmd.CopilotChatOpen()
              vim.api.nvim_win_close(windows[1], true)
          else
            vim.cmd.CopilotChatToggle()
          end
        end,
        desc = 'Toggle Copilot Chat',
      },
    },
    cmd = {
      'CopilotChat',
      'CopilotChatOpen',
      'CopilotChatClose',
      'CopilotChatToggle',
      'CopilotChatPrompts',
      'CopilotChatModels',
      'CopilotChatAgents',
      'CopilotChatLoad',
    },
  },
}
