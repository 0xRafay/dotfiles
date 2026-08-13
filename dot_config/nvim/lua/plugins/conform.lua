return {
  {
    'williamboman/mason.nvim',
    opts = {},
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    dependencies = { 'williamboman/mason.nvim' },
    config = function()
      require('mason-tool-installer').setup({
        ensure_installed = {
          'stylua',
          'clang-format',
          'google-java-format',
          'prettierd',
          'black',
          'isort',
          'eslint_d',
        },
        run_on_start = true,
        auto_update = true,
      })
    end,
  },
  {
    'stevearc/conform.nvim',
    opts = {
      formatters_by_ft = {
        lua = { 'stylua' },
        c = { 'clang-format' },
        cpp = { 'clang-format' },
        javascript = { 'prettierd', 'prettier' },
        html = { 'prettierd', 'prettier' },
        css = { 'prettierd', 'prettier' },
        java = { 'google-java-format' },
      },
      formatters = {
        stylua = {
          args = {
            '--search-parent-directories',
            '--stdin-filepath',
            '$FILENAME',
            '--indent-type',
            'Spaces',
            '--indent-width',
            '2',
            '--quote-style',
            'AutoPreferSingle',
            '-',
          },
        },
        ['google-java-format'] = {
          args = {
            '--aosp',
            '-',
          },
        },
      },
      --[[
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
    --]]
    },
    config = function(_, opts)
      require('conform').setup(opts)
    end,
    keys = {
      {
        '<leader>FF',
        function()
          require('conform').format({ lsp_fallback = true, async = true })
        end,
        desc = 'Format file (async)',
      },
    },
  },
}
