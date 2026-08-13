return {
  'mfussenegger/nvim-lint',
  event = { 'BufReadPre', 'BufEnter'},
  cond = function()
    return vim.fn.expand('%t') ~= '' and vim.bo.filetype == ''
  end,
  dependencies = {
    'williamboman/mason.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },

  config = function()
    local lint = require('lint')

    vim.diagnostic.config({
      virtual_text = false,
      signs = true,
      update_in_insert = false,
      severity_sort = true,
      float = {
        border = 'single',
        source = true,
      },
    })

    lint.linters_by_ft = {
      javascript = { 'eslint_d' },
      typescript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
      python = { 'ruff' },
      lua = { 'luacheck' },
      sh = { 'shellcheck' },
      bash = { 'shellcheck' },
      markdown = { 'rumdl' },
      json = { 'jsonlint' },
      yaml = { 'yamllint' },
    }

    local seen = {}
    local unique_linters = {}
    for _, linters in pairs(lint.linters_by_ft) do
      for _, linter in ipairs(linters) do
        if not seen[linter] then
          seen[linter] = true
          table.insert(unique_linters, linter)
        end
      end
    end

    require('mason-tool-installer').setup({
      ensure_installed = unique_linters,
      run_on_start = true,
      auto_update = false,
    })

    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('Linting', { clear = true }),
      callback = function()
        local ft = vim.bo.filetype
        if lint.linters_by_ft[ft] then
          pcall(lint.try_lint)
        end
      end,
    })
  end,
}
