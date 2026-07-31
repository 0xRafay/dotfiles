local ok, lint = pcall(require, 'lint')
if not ok then
  return
end

lint.linters_by_ft = {
}

-- Trigger linting automatically on save/enter
vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufEnter', 'InsertLeave' }, {
  group = vim.api.nvim_create_augroup('Linting', { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})
