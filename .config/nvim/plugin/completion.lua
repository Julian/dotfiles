local cmp = require'cmp'

vim.opt.completeopt = { 'menu', 'menuone', 'noselect' }

local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

cmp.setup{
  snippet = { expand = function(args) vim.fn["vsnip#anonymous"](args.body) end },
  mapping = {
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<CR>'] = cmp.mapping.confirm(),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif vim.fn["vsnip#available"]() == 1 then
        feedkey("<Plug>(vsnip-expand-or-jump)", "")
      elseif has_words_before() then
        cmp.complete()
      else
        fallback() -- <Tab>
      end
    end, { "i", "s" }),

    ["<S-Tab>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item()
      elseif vim.fn["vsnip#jumpable"](-1) == 1 then
        feedkey("<Plug>(vsnip-jump-prev)", "")
      end
    end, { "i", "s" }),
  },
  sources = {
    { name = 'nvim_lsp' },
    { name = 'nvim_lsp_document_symbol' },
    { name = 'vsnip' },
    { name = 'buffer' },
  }
}
cmp.setup.cmdline(':', {
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})
cmp.setup.cmdline('/', {
  sources = {
    { name = 'buffer' }
  }
})

_G.mappings = {
  i = {};
  n = {
    ['CR'] = function()
      local filetype = vim.opt.filetype:get()
      if filetype == 'qf' or vim.fn.bufname() == '[Command Line]' then return t '<CR>'
      elseif filetype == 'help' then return t '<C-]>'
      elseif filetype == 'vimwiki' then return t ':VimwikiFollowLink<CR>'
      else return t ':<C-U>SplitSensibly<CR>:VimwikiIndex<CR>'
      end
    end;
  };
}

for each, _ in pairs(_G.mappings.i) do
  local lhs = '<' .. each:gsub("_", "-") .. '>'
  local rhs = 'v:lua.mappings.i.' .. each .. '()'
  vim.api.nvim_set_keymap('i', lhs, rhs, { expr = true })
  vim.api.nvim_set_keymap('s', lhs, rhs, { expr = true })
end

for each, _ in pairs(_G.mappings.n) do
  local lhs = '<' .. each:gsub("_", "-") .. '>'
  local rhs = 'v:lua.mappings.n.' .. each .. '()'
  vim.api.nvim_set_keymap('n', lhs, rhs, { expr = true, noremap = true })
end

vim.cmd[[
highlight! CmpItemAbbrMatch guibg=NONE guifg=#569CD6
highlight! CmpItemAbbrMatchFuzzy guibg=NONE guifg=#569CD6
highlight! CmpItemKindFunction guibg=NONE guifg=#C586C0
highlight! CmpItemKindMethod guibg=NONE guifg=#C586C0
highlight! CmpItemKindVariable guibg=NONE guifg=#9CDCFE
highlight! CmpItemKindKeyword guibg=NONE guifg=#D4D4D4
]]
