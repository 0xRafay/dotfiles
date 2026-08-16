return {
  'nvim-java/nvim-java',
  dependencies = {
    'neovim/nvim-lspconfig',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('java').setup()
    vim.lsp.enable('jdtls')
  end,
}
