return {
  'folke/which-key.nvim',
  event = 'VeryLazy',
  opts = {
    win = {
      no_overlap = true,
      width = { min = 40, max = 50 },
      height = { min = 4, max = 20 },
      col = math.huge,
      -- row = 0.90,
      border = 'rounded',
      padding = { 1, 2 }, -- [top/bottom, right/left]
      title = false,
      title_pos = 'center',
      zindex = 1000,
      bo = {},
      wo = {
        winblend = 10, -- 0 for fully opaque and 100 for fully transparent
      },
    },
  },
  keys = {
    {
      '<leader>?',
      function()
        require('which-key').show({ global = false })
      end,
      desc = 'Buffer Local Keymaps (which-key)',
    },
  },
}
