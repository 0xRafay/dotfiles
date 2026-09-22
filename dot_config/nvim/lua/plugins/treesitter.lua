return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPost', 'BufNewFile' },
    cmd = { 'TSInstall', 'TSBufEnable', 'TSBufDisable', 'TSModuleInfo' },
    build = ':TSUpdate | TSInstallAll',
    config = function()
      local ts = require('nvim-treesitter')
      local parsers = {
        -- languages
        'javascript',
        'c',
        'cpp',
        'java',
        'c_sharp',
        'lua',
        'luadoc',
        'rust',
        'bash',
        --
        'latex',
        'markdown',
        'markdown_inline',
        'css',
        'svelte',
        'json',
        'toml',
        'yaml',
        'comment',
        'diff',
        'query',
        'regex',
      }
      ts.install(parsers)

      vim.api.nvim_create_autocmd('FileType', {
        pattern = parsers,
        callback = function()
          vim.treesitter.start()
        end,
      })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    opts = {
      enable = true,
      max_lines = 3,
      multiline_threshold = 1,
      trim_scope = 'outer',
      mode = 'cursor',
      exclude = { 'markdown', 'latex' },
    },
  },
}
