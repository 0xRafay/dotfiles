return {
  'olimorris/onedarkpro.nvim',
  priority = 1000,
  lazy = false,
  opts = {
    highlights = {},
    colors = {
      onedark_dark = { bg = '#050505' },
    },
  },
  init = function()
    vim.cmd('colorscheme onedark_dark')
  end,
}
--[[
return {
  "Shatur/neovim-ayu",
  priority = 1000,
  config = function()
    require('ayu').setup({
      terminal = false,
    })
    require('ayu').colorscheme()
  end
}
--]]
