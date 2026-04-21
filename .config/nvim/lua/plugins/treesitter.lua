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
    branch = 'main',
    lazy = false,
    dependencies = {
      { 'nvim-treesitter/nvim-treesitter-context', opts = {} },
      { 'RRethy/nvim-treesitter-endwise' },
      {
        'nvim-treesitter/nvim-treesitter-textobjects',
        branch = 'main',
        config = function()
          local select = require('nvim-treesitter-textobjects.select').select_textobject
          local keymaps = {
            ['aa'] = '@parameter.outer',
            ['ia'] = '@parameter.inner',
            ['ac'] = '@class.outer',
            ['ic'] = '@class.inner',
            ['af'] = '@function.outer',
            ['if'] = '@function.inner',
            ['al'] = '@loop.outer',
            ['il'] = '@loop.inner',
          }
          for lhs, capture in pairs(keymaps) do
            vim.keymap.set({ 'x', 'o' }, lhs, function()
              select(capture, 'textobjects')
            end)
          end
        end,
      },
    },
    build = function()
      vim.cmd('TSUpdate')
      if #parsers > 0 then
        require('nvim-treesitter').install(parsers)
      end
    end,
    config = function()
      if vim.env.DEVELOPMENT then
        local tsl_url = vim.fs.joinpath(vim.env.DEVELOPMENT, 'tree-sitter-lean')
        if not uv.fs_stat(tsl_url) then
          tsl_url = 'https://github.com/Julian/tree-sitter-lean'
        end
        require('nvim-treesitter.parsers').lean = {
          install_info = {
            url = tsl_url,
            files = { 'src/parser.c', 'src/scanner.c' },
          },
        }
      end
      require('nvim-treesitter-endwise').init()
    end,
  }
}
