vim.o.completeopt = "menuone,noselect"

local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    if col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        return true
    else
        return false
    end
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
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
end

_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    return t "<S-Tab>"
  end
end

require'compe'.setup{
  autocomplete = false,
  source = {
    buffer = { priority = 500 },
    calc = { priority = 500 },
    nvim_lsp = { priority = 500 },
    nvim_lua = { priority = 500 },
    nvim_treesitter = { priority = 500 },
    path = { priority = 500 },
    tags = { priority = 500 },
    vsnip = { priority = 500 },
  }
}

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
