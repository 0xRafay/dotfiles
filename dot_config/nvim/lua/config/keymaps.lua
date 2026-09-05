vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

local keymap = vim.keymap.set

keymap('n', '<leader>e', vim.diagnostic.open_float, { desc = 'Show line [E]rror diagnostics' })

keymap('n', '<Esc>', '<cmd>nohlsearch<CR>', { desc = 'Clear search highlight' })

keymap('n', '<leader>l', function()
  pcall(lint.try_lint)
end, { desc = 'Lint file' })

keymap('n', 'gs', function()
  vim.lsp.buf.signature_help()
end, opts)

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

-- DAP
keymap('n', '<F5>', function()
  require('dap').continue()
end)

keymap('n', '<F10>', function()
  require('dap').step_over()
end, { desc = 'Step Over' })

keymap('n', '<F11>', function()
  require('dap').step_into()
end, { desc = 'Step Into' })

keymap('n', '<F12>', function()
  require('dap').step_out()
end, { desc = 'Step Out' })

keymap('n', '<leader>b', function()
  require('dap').toggle_breakpoint()
end, { desc = 'Toggle BreakPoint' })

keymap('n', '<leader>B', function()
  require('dap').set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { desc = 'Set BreakPoint' })

keymap('n', '<leader>dr', function()
  require('dap').repl.open()
end)

keymap('n', '<leader>dl', function()
  require('dap').run_last()
end)

keymap('n', '<leader>dx', function()
  require('dap').terminate()
end, { desc = 'Terminate Debug' })

keymap('n', '<leader>du', function()
  require('dapui').toggle()
end, { desc = 'Toggle Debug UI' })

keymap('n', '<leader>d?', function()
  require('dapui').eval()
end, { desc = 'Evaluate expression' })
