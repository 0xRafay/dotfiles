vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local keymap = vim.keymap.set

keymap('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show line [E]rror diagnostics' })

keymap('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

keymap('n', '<leader>l', function()
  pcall(lint.try_lint)
end, { desc = 'Lint file' })

-- Diagnostic
keymap('n', '<leader>ld', function()
  vim.diagnostic.open_float()
end, { desc = 'Show diagnostics' })

keymap('n', ']d', function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = 'Next diagnostic' })

keymap('n', '[d', function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = 'Previous diagnostic' })

keymap('n', ']w', function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.WARN })
end, { desc = 'Next warning' })

keymap('n', '[w', function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.WARN })
end, { desc = 'Previous warning' })

keymap('n', ']e', function()
  vim.diagnostic.jump({ count = 1, severity = vim.diagnostic.severity.ERROR })
end, { desc = 'Next error' })

keymap('n', '[e', function()
  vim.diagnostic.jump({ count = -1, severity = vim.diagnostic.severity.ERROR })
end, { desc = 'Previous error' })
