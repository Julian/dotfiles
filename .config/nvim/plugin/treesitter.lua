require('nvim-treesitter.configs').setup{
  ensure_installed = {
    'bash', 'c', 'c_sharp', 'clojure', 'cmake', 'comment', 'cpp', 'css',
    'cuda', 'dockerfile', 'dot', 'haskell', 'html', 'java', 'javascript',
    'json', 'latex', 'llvm', 'lua', 'make', 'markdown', 'ninja', 'nix',
    'python', 'query', 'regex', 'rst', 'ruby', 'rust', 'tlaplus', 'toml',
    'typescript', 'vim', 'yaml', 'zig',
  },
  ignore_install = { 'phpdoc' },
  highlight = {
    enable = true,
    disable = { 'rst' },
  },
  indent = {
    enable = true,
    disable = { 'python' },
  },
  playground = {
    enable = true,
    disable = {},
    updatetime = 25,
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
  }
}
