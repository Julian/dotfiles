-- See https://github.com/theHamsta/nvim-semantic-tokens/blob/master/doc/nvim-semantic-tokens.txt
local mappings = {
  LspKeyword = "@keyword",
  LspVariable = "@variable",
  LspNamespace = "@namespace",
  LspType = "@type",
  LspClass = "@type.builtin",
  LspEnum = "@constant",
  LspInterface = "@type.definition",
  LspStruct = "@structure",
  LspTypeParameter = "@type.definition",
  LspParameter = "@parameter",
  LspProperty = "@property",
  LspEnumMember = "@field",
  LspEvent = "@variable",
  LspFunction = "@function",
  LspMethod = "@method",
  LspMacro = "@macro",
  LspModifier = "@keyword.function",
  LspComment = "@comment",
  LspString = "@string",
  LspNumber = "@number",
  LspRegexp = "@string.special",
  LspOperator = "@operator",
}

for from, to in pairs(mappings) do
  vim.cmd.highlight('link ' .. from .. ' ' .. to)
end
