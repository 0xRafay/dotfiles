return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  opts = {

    marksman = {},

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
    vim.lsp.handlers['textDocument/signatureHelp'] = function(err, result, ctx)
      return vim.lsp.handlers.signature_help(err, result, ctx, {
        border = 'rounded',
        focusable = true,
      })
    end
    for server, config in pairs(opts) do
      vim.lsp.config(server, config)
      vim.lsp.enable(server)
    end
  end,
}
