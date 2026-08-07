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
    
    -- Setup mason-lspconfig with the new API
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
    
    -- Configure LSP servers using vim.lsp.config (Neovim 0.11+)
    -- Option 1: Configure each server individually
    vim.lsp.config('lua_ls', {
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = { globals = { 'vim' } },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
        },
      },
    })
    
    vim.lsp.config('clangd', {
      capabilities = capabilities,
    })
    
    vim.lsp.config('ts_ls', {
      capabilities = capabilities,
    })
    
    vim.lsp.config('pyright', {
      capabilities = capabilities,
    })
    
    -- Enable the servers
    vim.lsp.enable('lua_ls')
    vim.lsp.enable('clangd')
    vim.lsp.enable('ts_ls')
    vim.lsp.enable('pyright')
  end,
}
