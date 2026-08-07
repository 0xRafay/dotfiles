return {
  'srcery-colors/srcery-vim',
  lazy = false,
  priority = 1000,
  config = function()
    vim.cmd([[colorscheme srcery]])

    local function set_highlight()
      vim.api.nvim_set_hl(0, 'Search', { bg = '#FAD02C', fg = '#000000', bold = true })
      vim.api.nvim_set_hl(0, 'CurSearch', { bg = '#FF5733', fg = '#FFFFFF', bold = true })
      vim.api.nvim_set_hl(0, 'IncSearch', { bg = '#FF5733', fg = '#FFFFFF', bold = true })
    end

    set_highlight()
  end,
}
