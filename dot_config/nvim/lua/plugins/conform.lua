return {
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
    },
    --[[
    format_on_save = {
      timeout_ms = 500,
      lsp_fallback = true,
    },
  },
    --]]

    -- This will be called automatically with the opts table
    config = function(_, opts)
      require('conform').setup(opts)
    end,
  },
  keys = {
    {
      '<leader>FF',
      function()
        require('conform').format({ lsp_fallback = true, async = true })
      end,
      desc = 'Format file (async)',
    },
  },
}
