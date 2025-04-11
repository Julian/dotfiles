return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    opts = {
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
      model = 'claude-3.7-sonnet-thought',
      chat_autocomplete = false,
      mappings = {
        complete = { normal = '', insert = '' },
        close = { normal = '', insert = '' },
        reset = { normal = '<localleader>r' },
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
        function() require('CopilotChat').toggle() end,
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
    },
  },
}
