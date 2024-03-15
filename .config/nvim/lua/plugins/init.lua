return {
  {
    'rebelot/kanagawa.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      require('kanagawa').setup{}
      vim.cmd[[
        colorscheme kanagawa
        highlight link FloatBorder Fg
      ]]
    end,
  },

  { 'AndrewRadev/linediff.vim', cmd = { 'Linediff', 'LinediffReset' } },
  {
    'AndrewRadev/splitjoin.vim',
    cmd = { 'SplitjoinJoin', 'SplitjoinSplit' },
  },
  { 'AndrewRadev/switch.vim', lazy = false },
  { 'andymass/vim-matchup', lazy = false },
  { 'bruno-/vim-vertical-move' },
  { 'dahu/vim-fanfingtastic', lazy = false },
  { 'easymotion/vim-easymotion' },
  { 'godlygeek/tabular', cmd = 'Tabularize' },
  { 'itchyny/lightline.vim', lazy = false },
  { 'jmcantrell/vim-diffchanges', cmd = 'DiffChangesDiffToggle' },
  {
    'kshenoy/vim-signature',
    init = function()
      vim.g.SignatureMap = {
        Leader = 'M',
        PlaceNextMark = 'M,',
        PurgeMarks = 'M<Space>',
        PurgeMarkers = 'M<BS>',
        GotoNextLineAlpha = '',
        GotoPrevLineAlpha = '',
        GotoNextSpotAlpha = '',
        GotoPrevSpotAlpha = '',
        GotoNextLineByPos = '',
        GotoPrevLineByPos = '',
        GotoNextSpotByPos = '',
        GotoPrevSpotByPos = '',
        GotoNextMarker = ']-',
        GotoPrevMarker = '[-',
        GotoNextMarkerAny = ']=',
        GotoPrevMarkerAny = '[=',
      }
    end,
  },
  { 'liuchengxu/vista.vim', cmd = 'Vista' },
  {
    'mbbill/undotree',
    init = function() vim.g.undotree_TreeNodeShape = '✷' end,
  },
  {
    'mhinz/vim-signify',
    lazy = false,
    init = function()
      vim.g.signify_mapping_next_hunk = '<nop>'
      vim.g.signify_mapping_prev_hunk = '<nop>'
      vim.g.signify_mapping_toggle_highlight = '<nop>'
      vim.g.signify_mapping_toggle = '<nop>'

      vim.g.signify_update_on_bufenter = 0
      vim.g.signify_vcs_list = { 'git', 'hg' }
    end,
  },
  { 'nathanaelkane/vim-indent-guides', cmd = 'IndentGuidesToggle' },
  {
    't9md/vim-quickhl',
    cmd = 'QuickhlManualReset',
  },
  {
    'tommcdo/vim-exchange',
    init = function() vim.g.exchange_no_mappings = true end,
    lazy = false,
  },
  { 'tomtom/tcomment_vim', lazy = false },
  { 'tpope/vim-abolish', cmd = { 'Abolish', 'S' } },
  { 'tpope/vim-fugitive', lazy = false },
  { 'tpope/vim-obsession', cmd = 'Obsession' },
  { 'tpope/vim-repeat', lazy = false },
  { 'tpope/vim-rhubarb', lazy = false },
  { 'tpope/vim-surround', lazy = false },
  { 'Valodim/vim-zsh-completion' },
  {
    'vimwiki/vimwiki',
    branch = 'dev',
    cmd = 'VimwikiIndex',
    init = function()
      vim.g.vimwiki_key_mappings = { all_maps = 0 }
      vim.g.vimwiki_list = {
        {
          path = vim.env.XDG_DATA_HOME .. '/nvim/',
          index = 'global',
        },
      }
    end,
  },

  { 'b0o/schemastore.nvim' },
  { 'guns/vim-sexp', ft = 'clojure' },
  {
    'NoahTheDuke/vim-just',
    event = { 'BufReadPre justfile', 'BufNewFile justfile' },
  },
  { 'raimon49/requirements.txt.vim', ft = 'requirements', lazy = false },
  { 'stsewd/sphinx.nvim', build = ':UpdateRemotePlugins' },
  { 'tpope/vim-fireplace', ft = 'clojure' },
  { 'tpope/vim-salve', ft = 'clojure' },
  { 'tpope/vim-sexp-mappings-for-regular-people', ft = 'clojure' },

  { 'mfussenegger/nvim-lint' },
  { 'MunifTanjim/nui.nvim' },
  {
    'rcarriga/nvim-notify',
    opts = { max_width = 100 },
    init = function()
      vim.notify = function(...)
        vim.notify = require("notify")
        return vim.notify(...)
      end
    end,
  },

  { 'Julian/vim-runt', lazy = false, dev = true },
  {
    'Julian/vim-textobj-assignment',
    dev = true,
    dependencies = 'kana/vim-textobj-user',
    event = 'VeryLazy',
  },
  {
    'Julian/vim-textobj-variable-segment',
    dev = true,
    dependencies = 'kana/vim-textobj-user',
    event = 'VeryLazy',
  },
}
