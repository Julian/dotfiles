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
    lazy = false,
    keys = {
      { 's<CR>', vim.cmd.SplitjoinSplit },
      { 'ss', vim.cmd.SplitjoinJoin },
    },
  },
  { 'AndrewRadev/switch.vim', lazy = false },
  {
    'andymass/vim-matchup',
    lazy = false,
    keys = {
      {
        '<C-j>',
        vim.cmd.MatchupWhereAmI,
        desc = 'Matchup Breadcrumbs',
      },
    },
    init = function()
      vim.g.matchup_matchparen_offscreen = { method = "popup" }
      vim.g.matchup_surround_enabled = 1
    end,
  },
  { 'bruno-/vim-vertical-move' },
  { 'dahu/vim-fanfingtastic', lazy = false },
  { 'easymotion/vim-easymotion' },
  { 'godlygeek/tabular', cmd = 'Tabularize' },
  {
    'nvim-lualine/lualine.nvim',
    lazy = false,
    opts = {
      options = { icons_enabled = false },
      sections = {
        lualine_c = {
          { 'filename', path = 1 }, -- absolute path
        },
        lualine_y = {
          --- Display Lean file progress when still processing, otherwise
          --- fallback to cursor progress via the normal lualine componnet.
          function()
            if vim.bo.filetype ~= 'lean' then
                return require('lualine.components.progress')()
            end

            local percentage = require'lean.progress'.percentage()
            if percentage >= 100 then
              return require('lualine.components.progress')()
            end
            return string.format('Processing… %.f%%%%', percentage)
          end
        },
      },
    },
  },
  { 'jmcantrell/vim-diffchanges', cmd = 'DiffChangesDiffToggle' },
  {
    'lewis6991/gitsigns.nvim',
    event = 'BufReadPost',
    opts = {},
  },
  {
    'lewis6991/satellite.nvim',
    event = 'BufReadPost',
  },
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
    cmd = 'UndotreeToggle',
    init = function() vim.g.undotree_TreeNodeShape = '✷' end,
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
  { 'b0o/schemastore.nvim' },
  { 'guns/vim-sexp', ft = 'clojure' },
  { 'raimon49/requirements.txt.vim', ft = 'requirements', lazy = false },
  { 'stsewd/sphinx.nvim', build = ':UpdateRemotePlugins' },
  { 'tpope/vim-fireplace', ft = 'clojure' },
  { 'tpope/vim-salve', ft = 'clojure' },
  { 'tpope/vim-sexp-mappings-for-regular-people', ft = 'clojure' },

  { 'mfussenegger/nvim-lint' },
  { 'MunifTanjim/nui.nvim' },
  {
    'rcarriga/nvim-notify',
    opts = { render = "wrapped-compact", max_width = 100 },
    init = function()
      vim.notify = function(...)
        vim.notify = require("notify")
        return vim.notify(...)
      end
    end,
  },

  {
    'Julian/runt.nvim',
    dev = true,
    keys = {
      {
        'd<CR>',
        function()
          require('runt').current_test_file():if_exists(_G.split)
        end,
        desc = 'Open the corresponding test file for the current file.',
      },
      {
        'dK',
        function() require('runt').follow() end,
        desc = 'Continuously follow opening the test file for any file in this buffer.',
      },
    }
  },
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
