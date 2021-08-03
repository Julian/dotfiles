vim.opt.completeopt = { 'menuone', 'noselect' }

require'compe'.setup{
  autocomplete = false,
  source = {
    buffer = { priority = 400 },
    calc = { priority = 500 },
    nvim_lsp = { priority = 500 },
    nvim_lua = { priority = 500 },
    nvim_treesitter = { priority = 500 },
    path = { priority = 500 },
    tags = { priority = 500 },
    vsnip = { priority = 500 },
  }
}

local check_back_space = function()
  local col = vim.fn.col('.') - 1
  if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
    return true
  else
    return false
  end
end

_G.mappings = {
  i = {
    ['Tab'] = function()
      local complete_info = vim.fn.complete_info()
      if complete_info.pum_visible == 1 then
        if vim.fn.len(complete_info.items) > 1 then
          return t "<C-n>"
        else
          local key = complete_info.selected == -1 and (t "<C-n>") or ""
          return key .. vim.fn['compe#confirm'](t "<CR>")
        end
      elseif vim.fn.call("vsnip#available", {1}) == 1 then
        return t "<Plug>(vsnip-expand-or-jump)"
      elseif check_back_space() then
        return t "<Tab>"
      else
        return vim.fn['compe#complete']()
      end
    end;
    ['S_Tab'] = function()
      if vim.fn.pumvisible() == 1 then
        return t "<C-p>"
      else
        return t "<S-Tab>"
      end
    end;
    ['CR'] = function()
      return vim.fn['compe#confirm']('\n' .. t('<Plug>DiscretionaryEnd'))
    end;
  };
  n = {
    ['CR'] = function()
      local filetype = vim.opt.filetype:get()
      if filetype == 'qf' then return t '<CR>'
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
