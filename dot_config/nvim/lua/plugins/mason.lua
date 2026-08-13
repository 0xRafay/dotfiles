return {
  'mason-org/mason.nvim',
  cmd = { 'Mason', 'MasonInstall', 'MasonUpdate' },
  opts = {
    PATH = 'skip',

    ui = {
      icons = {},
    },

    max_concurrent_installers = 10,
  },
}
