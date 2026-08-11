return {
  'olimorris/onedarkpro.nvim',
  priority = 1000,
  config = function()
    require('onedarkpro').setup({
      colors = {
        onedark_dark = { bg = '#050505' },
      },
    })

    vim.cmd('colorscheme onedark_dark')
  end,
}
