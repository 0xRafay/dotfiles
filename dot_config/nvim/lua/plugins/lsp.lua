return {
  'neovim/nvim-lspconfig',
  event = 'BufReadPre',
  dependencies = {
    'saghen/blink.cmp',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  },

  config = function()
    require('mason').setup()

    require('mason-lspconfig').setup({
      ensure_installed = {
        'lua_ls',
        'clangd',
        'ts_ls',
        'pyright',
        'rust_analyzer',
      },
      automatic_installation = true,
      automatic_enable = {
        exclude = {
          'jdtls',
        },
      },
    })

    local capabilities = require('blink.cmp').get_lsp_capabilities()

    local servers = {
      'lua_ls',
      'clangd',
      'ts_ls',
      'pyright',
      'rust_analyzer',
    }

    for _, server in ipairs(servers) do
      vim.lsp.config(server, {
        capabilities = capabilities,
      })
    end

    vim.lsp.config('lua_ls', {
      settings = {
        Lua = {
          diagnostics = { globals = { 'vim' } },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    })

    for _, server in ipairs(servers) do
      vim.lsp.enable(server)
    end
  end,
}
