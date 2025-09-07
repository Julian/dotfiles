local uv = vim.loop or vim.uv

local parsers = {}
if vim.env.DEVELOPMENT and uv.fs_stat(vim.env.DEVELOPMENT) then
  parsers = {
    'bash', 'beancount', 'c', 'c_sharp', 'clojure', 'cmake', 'comment',
    'cpp', 'css', 'cuda', 'dockerfile', 'dot', 'haskell', 'html', 'java',
    'javascript', 'json', 'just', 'latex', 'llvm', 'lua', 'make', 'markdown',
    'ninja', 'nix', 'python', 'query', 'regex', 'rst', 'ruby', 'rust',
    'tlaplus', 'toml', 'typescript', 'vim', 'yaml', 'zig',
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
      local configs = require('nvim-treesitter.parsers').get_parser_configs()

      local tsl_url = vim.fs.joinpath(vim.env.DEVELOPMENT, 'tree-sitter-lean')
      if not uv.fs_stat(tsl_url) then
        tsl_url = 'https://github.com/Julian/tree-sitter-lean'
      end

      ---@diagnostic disable-next-line: inject-field
      configs.lean = {
        install_info = {
          url = tsl_url,
          files = {"src/parser.c", "src/scanner.c"},
        },
      }
      ---@diagnostic disable-next-line: inject-field
      configs.vhs = {
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
        matchup = { enable = true },
        textobjects = {
          select = {
            enable = true,
            keymaps = {
              ['aa'] = '@parameter.outer',
              ['ia'] = '@parameter.inner',
              ['ac'] = '@class.outer',
              ['ic'] = '@class.inner',
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
              ['al'] = '@loop.outer',
              ['il'] = '@loop.inner',
            },
          },
        },
      }
    end,
  }
}
