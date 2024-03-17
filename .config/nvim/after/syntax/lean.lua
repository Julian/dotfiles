-- See https://github.com/theHamsta/nvim-semantic-tokens/blob/master/doc/nvim-semantic-tokens.txt
local mappings = {
  ['@lsp.type.keyword'] = '@keyword',
  ['@lsp.type.variable'] = 'Identifier',
}

for from, to in pairs(mappings) do
  vim.cmd.highlight('link ' .. from .. ' ' .. to)
end
