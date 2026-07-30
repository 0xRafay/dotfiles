local ok, conform = pcall(require, 'conform')

if not ok then
  return
end

conform.setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    c = { 'clang-format' },
    cpp = { 'clang-format' },
    javascript = { 'prettierd', 'prettier' },
    html = { 'prettierd', 'prettier' },
    css = { 'prettierd', 'prettier' },
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
        'AutoPreferSingle', -- Force single-quotes!
        '-',
      },
    },
  },

  --[[
  format_on_save = {
    timeout_ms = 500,
    lsp_fallback = true,
  },
  ]]
  --

  vim.keymap.set({ 'n', 'v' }, '<leader>FF', function()
    conform.format({
      lsp_fallback = true,
      async = false,
      timeout_ms = 500,
    })
  end, { desc = '[F]ormat current buffer' }),
})
