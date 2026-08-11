return {
  'olimorris/onedarkpro.nvim',
  priority = 1000, -- Ensure it loads first
  config = function()
    local function setup()
      vim.cmd('colorscheme onedark_dark')
    end
    setup()
  end,
}
