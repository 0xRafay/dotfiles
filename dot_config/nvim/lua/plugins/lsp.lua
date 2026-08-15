return {
  'neovim/nvim-lspconfig',
  event = { 'User FilePost', 'BufReadPost' },
  opts = {
    clangd = {},

    ts_ls = {},

    lua_ls = {
      settings = {
        Lua = {
          diagnostics = {
            globals = { 'vim' },
          },
          workspace = {
            checkThirdParty = false,
          },
          telemetry = {
            enable = false,
          },
        },
      },
    },
    bashls = {},

    rust_analyzer = {},

    ruff = {},
  },

  config = function(_, opts)
    for server, config in pairs(opts) do
      vim.lsp.config(server, config)
      vim.lsp.enable(server)
    end
  end,
}
