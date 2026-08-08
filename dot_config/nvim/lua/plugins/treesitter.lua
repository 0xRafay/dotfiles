return {
  'nvim-treesitter/nvim-treesitter',
  branch = 'main',
  build = ':TSUpdate',
  version = false,
  lazy = false,
  config = function()
    local ts = require('nvim-treesitter')
    local parsers = {
      -- languages
      'javascript',
      'c',
      'cpp',
      'java',
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
}
