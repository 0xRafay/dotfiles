return {
  'srcery-colors/srcery-vim',
  lazy = false,
  priority = 1000,
  config = function()
    -- this has to be here, before the theme loads
    local function set_theme_options()
      vim.g.srcery_italic = 1
      vim.g.srcery_bold = 1
      vim.g.srcery_underline = 0
      vim.g.srcery_inverse = 0
    end

    set_theme_options()

    vim.cmd([[colorscheme srcery]])

    local function set_highlight()
      vim.api.nvim_set_hl(0, 'Search', { bg = '#FAD02C', fg = '#000000', bold = true })
      vim.api.nvim_set_hl(0, 'CurSearch', { bg = '#FF5733', fg = '#FFFFFF', bold = true })
      vim.api.nvim_set_hl(0, 'IncSearch', { bg = '#FF5733', fg = '#FFFFFF', bold = true })
    end

    set_highlight()
  end,
}
