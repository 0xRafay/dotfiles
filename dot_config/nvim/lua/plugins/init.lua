return {
{
    "srcery-colors/srcery-vim",
    lazy = false,
    priority = 1000,
    config = function()
      vim.cmd([[colorscheme srcery]])
    end,
  },
    "NMAC427/guess-indent.nvim",
    'nvim-tree/nvim-web-devicons',
    'nvim-lualine/lualine.nvim',
    'mfussenegger/nvim-lint',
    'lukas-reineke/indent-blankline.nvim',

  'neovim/nvim-lspconfig',
  'williamboman/mason.nvim',
  'williamboman/mason-lspconfig.nvim',
  'WhoIsSethDaniel/mason-tool-installer.nvim',
'stevearc/conform.nvim',
'L3MON4D3/LuaSnip',
'https://codeberg.org/mfussenegger/nvim-jdtls.git',
}
