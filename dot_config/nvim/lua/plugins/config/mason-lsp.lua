local ok, mason_lsp = pcall(require, 'mason-lspconfig')
if not ok then
  return
end

mason_lsp.setup({
  handlers = {
    function(server_name)
      vim.lsp.config(server_name, {
        capabilities = require('cmp_nvim_lsp').default_capabilities(), -- for autocomplete[citation:6]
      })
    end,
  },
})
