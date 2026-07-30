local mason_ok, mason = pcall(require, 'mason')
local installer_ok, installer = pcall(require, 'mason-tool-installer')
if not (mason_ok and installer_ok) then
  return
end

mason.setup()

-- automatically grab LSP names from lsp.lua table
local ensure_installed = vim.tbl_keys(_G.lsp_servers or {})

-- extend the list with non-LSP tools (Formatters / Linters)
vim.list_extend(ensure_installed, {
  'stylua',
  'clang-format',

  'markdownlint',

  'prettier',
  'prettierd',
  'html-lsp',
  'cssls',
})

installer.setup({
  ensure_installed = ensure_installed,
  run_on_start = true,
})
