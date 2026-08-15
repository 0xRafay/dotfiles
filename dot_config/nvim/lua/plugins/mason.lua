return {
  {
    'mason-org/mason.nvim',
    cmd = { 'Mason', 'MasonInstall', 'MasonUpdate' },
    opts = {
      PATH = 'skip',

      ui = {
        icons = {},
      },

      max_concurrent_installers = 10,
    },
  },
  {
    'whoissethdaniel/mason-tool-installer.nvim',
    event = { 'User FilePost' },
  },
  {
    'williamboman/mason-lspconfig.nvim',
    event = {'User FilePost'},
  },
}
