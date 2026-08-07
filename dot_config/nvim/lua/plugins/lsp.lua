return {
  'neovim/nvim-lspconfig',
  dependencies = { 
    'saghen/blink.cmp',
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
  },
  
  config = function()
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    
    -- Setup Mason
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
    })
    
    require('mason-lspconfig').setup_handlers({
      -- The first entry (without a key) will be the default handler
      function(server)
        vim.lsp.config(server, {
          capabilities = capabilities,
        })
        vim.lsp.enable(server)
      end,
      
      -- Override specific servers
      ['lua_ls'] = function(server)
        vim.lsp.config(server, {
          capabilities = capabilities,
          settings = {
            Lua = {
              diagnostics = { globals = { 'vim' } },
              workspace = { checkThirdParty = false },
              telemetry = { enable = false },
            },
          },
        })
        vim.lsp.enable(server)
      end,
    })
  end,
}
