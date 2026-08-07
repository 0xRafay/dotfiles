return {
  'mfussenegger/nvim-lint',
  dependencies = {
    'williamboman/mason.nvim',
    'WhoIsSethDaniel/mason-tool-installer.nvim',
  },

  config = function()
    local lint = require('lint')

    -- Configure diagnostics globally
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

    -- Configure linters
    lint.linters_by_ft = {
      javascript = { 'eslint_d' },
      typescript = { 'eslint_d' },
      javascriptreact = { 'eslint_d' },
      typescriptreact = { 'eslint_d' },
      python = { 'pylint' },
      lua = { 'luacheck' },
      sh = { 'shellcheck' },
      bash = { 'shellcheck' },
      markdown = { 'vale' },
      json = { 'jsonlint' },
      yaml = { 'yamllint' },
    }

    -- Get unique linters
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

    -- Install linters
    require('mason-tool-installer').setup({
      ensure_installed = unique_linters,
      run_on_start = true,
      auto_update = true,
    })

    -- Auto-lint
    vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter', 'InsertLeave' }, {
      group = vim.api.nvim_create_augroup('Linting', { clear = true }),
      callback = function()
        local ft = vim.bo.filetype
        if lint.linters_by_ft[ft] then
          pcall(lint.try_lint)
        end
      end,
    })

    -- Keymaps using new API
    local map = vim.keymap.set

    map('n', '<leader>l', function()
      pcall(lint.try_lint)
    end, { desc = 'Lint file' })

    map('n', '<leader>ld', function()
      vim.diagnostic.open_float()
    end, { desc = 'Show diagnostics' })

    -- Jump to diagnostics (new API)
    map('n', ']d', function()
      vim.diagnostic.jump({ count = 1 })
    end, { desc = 'Next diagnostic' })

    map('n', '[d', function()
      vim.diagnostic.jump({ count = -1 })
    end, { desc = 'Previous diagnostic' })

    -- Jump to warnings
    map('n', ']w', function()
      vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN })
    end, { desc = 'Next warning' })

    map('n', '[w', function()
      vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN })
    end, { desc = 'Previous warning' })

    -- Jump to errors
    map('n', ']e', function()
      vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
    end, { desc = 'Next error' })

    map('n', '[e', function()
      vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
    end, { desc = 'Previous error' })
  end,
}
