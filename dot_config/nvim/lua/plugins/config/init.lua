---@param repo string
---@return string
local function gh(repo)
  return 'https://github.com/' .. repo
end

vim.pack.add({ gh('m4xshen/hardtime.nvim') })

-- Colorschemes
vim.pack.add({ gh('srcery-colors/srcery-vim') })

-- GuessIndent
vim.pack.add({ gh('NMAC427/guess-indent.nvim') })

-- DevIcons
vim.pack.add({ gh('nvim-tree/nvim-web-devicons') })

-- Lualine
vim.pack.add({ gh('nvim-lualine/lualine.nvim') })

-- Lint
vim.pack.add({ gh('mfussenegger/nvim-lint') })

-- Indent Lines
vim.pack.add({
  gh('lukas-reineke/indent-blankline.nvim'),
})

-- Lsp, Mason & Friends
vim.pack.add({
  gh('neovim/nvim-lspconfig'),
  gh('williamboman/mason.nvim'),
  gh('williamboman/mason-lspconfig.nvim'),
  gh('WhoIsSethDaniel/mason-tool-installer.nvim'),
})

-- Formatter
vim.pack.add({ gh('stevearc/conform.nvim') })

-- Completion
vim.pack.add({ gh('L3MON4D3/LuaSnip') })
vim.pack.add({
  {
    src = gh('Saghen/blink.cmp'),
    version = 'v1',
  },
})

-- Java
vim.pack.add({
  'https://codeberg.org/mfussenegger/nvim-jdtls.git',
})

-- AutoPairs
vim.pack.add({ gh('windwp/nvim-autopairs') })

-- CCC
vim.pack.add({ gh('uga-rosa/ccc.nvim') })

require('plugins.config.colors.srcery')
require('plugins.config.guess-indent')
require('plugins.config.lualine')
require('plugins.config.lint')
require('plugins.config.conform')
require('plugins.config.luasnip')
require('plugins.config.blink')
require('plugins.config.blankline')
require('plugins.config.autopairs')
require('plugins.config.ccc')
require('plugins.config.jdtls')

require('plugins.config.hardtime')

-- The order here is important:
require('plugins.config.mason')
require('plugins.config.mason-lsp')
require('plugins.config.lsp')
