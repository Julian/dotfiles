local has_words_before = function()
  local _, col = unpack(vim.api.nvim_win_get_cursor(0))
  local line = vim.api.nvim_get_current_line()
  return col ~= 0 and not line:sub(col, col):match '%s'
end

return {
  { 'giuxtaposition/blink-cmp-copilot' },
  {
    'saghen/blink.cmp',
    version = 'v0.*',

    lazy = false,
    dependencies = { 'giuxtaposition/blink-cmp-copilot' },

    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      keymap = {
        ['<C-space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>'] = { 'hide', 'fallback' },

        ['<C-p>'] = { 'show', 'select_prev', 'fallback' },
        ['<C-n>'] = { 'show', 'select_next', 'fallback' },

        ['<C-b>'] = { 'scroll_documentation_up', 'fallback' },
        ['<C-f>'] = { 'scroll_documentation_down', 'fallback' },

        ['<Tab>'] = {
          function(cmp)
            if not has_words_before() then
              return
            end
            return cmp.select_and_accept()
          end,
          'snippet_forward',
          'fallback'
        },
        ['<S-Tab>'] = { 'snippet_backward', 'fallback' },
      },
      -- until https://github.com/rebelot/kanagawa.nvim/pull/263 is merged
      appearance = { use_nvim_cmp_as_default = true },
      cmdline = { enabled = false },
      completion = {
        accept = { auto_brackets = { enabled = false } },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        list = { selection = { preselect = function(ctx) return ctx.mode ~= 'cmdline' end } },
        menu = { auto_show = function(ctx) return ctx.mode ~= 'cmdline' end },
      },
      signature = { enabled = true },
      sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer', 'copilot', 'lazydev' },
        providers = {
          copilot = {
            name = 'copilot',
            module = 'blink-cmp-copilot',
            score_offset = 100,
            async = true,
          },
          lazydev = {
            name = 'LazyDev',
            module = 'lazydev.integrations.blink',
            score_offset = 100,
          },
        },
      },
    },
  },
}
