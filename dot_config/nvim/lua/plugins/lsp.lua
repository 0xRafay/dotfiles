return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'saghen/blink.cmp',
  },

  config = function()
    local M = {}
    local map = vim.keymap.set

    -- export on_attach & capabilities
    M.on_attach = function(_, bufnr)
      local function opts(desc)
        return { buffer = bufnr, desc = 'LSP ' .. desc }
      end

      map('n', 'gD', vim.lsp.buf.declaration, opts('Go to declaration'))
      map('n', 'gd', vim.lsp.buf.definition, opts('Go to definition'))
      map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts('Add workspace folder'))
      map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts('Remove workspace folder'))

      map('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, opts('List workspace folders'))

      map('n', '<leader>D', vim.lsp.buf.type_definition, opts('Go to type definition'))
    end

    -- disable semanticTokens
    M.on_init = function(client, _)
      if vim.fn.has('nvim-0.11') ~= 1 then
        if client.supports_method('textDocument/semanticTokens') then
          client.server_capabilities.semanticTokensProvider = nil
        end
      else
        if client:supports_method('textDocument/semanticTokens') then
          client.server_capabilities.semanticTokensProvider = nil
        end
      end
    end

    M.capabilities = vim.lsp.protocol.make_client_capabilities()

    M.capabilities.textDocument.completion.completionItem = {
      documentationFormat = { 'markdown', 'plaintext' },
      snippetSupport = true,
      preselectSupport = true,
      insertReplaceSupport = true,
      labelDetailsSupport = true,
      deprecatedSupport = true,
      commitCharactersSupport = true,
      tagSupport = { valueSet = { 1 } },
      resolveSupport = {
        properties = {
          'documentation',
          'detail',
          'additionalTextEdits',
        },
      },
    }

    M.defaults = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          M.on_attach(_, args.buf)
        end,
      })

      local servers = {
        'lua_ls',
        'pyright',
        'tsserver',
        'rust_analyzer',
        'clangd',
        'jsonls',
      }

      for _, server in ipairs(servers) do
        local config = {
          capabilities = M.capabilities,
          on_init = M.on_init,
        }

        local lua_lsp_settings = {
          Lua = {
            diagnostics = { globals = { 'vim' } },
            telemetry = { enable = false },
            runtime = { version = 'LuaJIT' },
            workspace = {
              checkThirdParty = false,
              library = {
                vim.fn.expand('$VIMRUNTIME/lua'),
                vim.fn.stdpath('data') .. '/lazy/ui/nvchad_types',
                vim.fn.stdpath('data') .. '/lazy/lazy.nvim/lua/lazy',
                '${3rd}/luv/library',
              },
            },
          },
        }
        if server == 'lua_ls' then
          config.settings = lua_lsp_settings
        end

        vim.lsp.config(server, config)
        vim.lsp.enable(server)
      end

      return M
    end
    M.defaults()
  end,
}
