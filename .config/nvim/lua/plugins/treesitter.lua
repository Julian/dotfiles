local uv = vim.loop or vim.uv

local parsers = {}
if uv.fs_stat(vim.env.DEVELOPMENT) then
  parsers = {
    'bash', 'c', 'c_sharp', 'clojure', 'cmake', 'comment', 'cpp', 'css',
    'cuda', 'dockerfile', 'dot', 'haskell', 'html', 'java', 'javascript',
    'json', 'latex', 'llvm', 'lua', 'make', 'markdown', 'ninja', 'nix', 'org',
    'python', 'query', 'regex', 'rst', 'ruby', 'rust', 'tlaplus', 'toml',
    'typescript', 'vim', 'yaml', 'zig',
  }
end

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = 'TSUpdate',
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-context', opts = {} },
      { 'RRethy/nvim-treesitter-endwise' },
      { 'nvim-treesitter/nvim-treesitter-textobjects' },
    },
    config = function()
      ---@diagnostic disable-next-line: inject-field
      require('nvim-treesitter.parsers').get_parser_configs().vhs = {
        install_info = {
          url = 'https://github.com/charmbracelet/tree-sitter-vhs',
          files = {"src/parser.c"},
        }
      }
      ---@diagnostic disable-next-line: missing-fields
      require('nvim-treesitter.configs').setup{
        ensure_installed = parsers,
        ignore_install = { 'phpdoc' },
        highlight = {
          enable = true,
          disable = { 'rst' },
          additional_vim_regex_highlighting = { 'org' },
        },
        indent = {
          enable = true,
        },
        query_linter = {
          enable = true,
          use_virtual_text = true,
          lint_events = { 'BufWrite', 'CursorHold' },
        },
        endwise = { enable = true },
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
            },
          },
        },
      }
    end,
  }
}
