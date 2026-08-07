return {
  'mfussenegger/nvim-jdtls',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'saghen/blink.cmp',
  },

  ft = { 'java' },

  config = function()
    local jdtls = require('jdtls')

    -- Ensure jdtls is installed via Mason
    require('mason').setup()
    require('mason-lspconfig').setup({
      ensure_installed = { 'jdtls' },
      automatic_installation = true,
    })

    local function setup_jdtls()
      local mason_path = vim.fn.stdpath('data') .. '/mason'
      local jdtls_path = mason_path .. '/packages/jdtls'

      -- Use vim.fn.glob to find the launcher jar
      local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')

      -- Detect OS and set config path
      local config_path
      if vim.fn.has('linux') == 1 then
        config_path = jdtls_path .. '/config_linux'
      elseif vim.fn.has('mac') == 1 then
        config_path = jdtls_path .. '/config_mac'
      elseif vim.fn.has('win32') == 1 then
        config_path = jdtls_path .. '/config_win'
      else
        vim.notify('Unsupported OS for jdtls', vim.log.levels.ERROR)
        return
      end

      local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', '.project' }
      local root_dir = require('jdtls.setup').find_root(root_markers)

      if not root_dir or root_dir == '' then
        return
      end

      local project_name = vim.fn.fnamemodify(root_dir, ':p:h:t')
      local workspace_dir = os.getenv('HOME') .. '/.cache/jdtls/workspace/' .. project_name
      vim.fn.mkdir(workspace_dir, 'p')

      local config = {
        cmd = {
          'java',
          '-Declipse.application=org.eclipse.jdt.ls.core.id1',
          '-Dosgi.bundles.defaultStartLevel=4',
          '-Declipse.product=org.eclipse.jdt.ls.core.product',
          '-Dlog.protocol=true',
          '-Dlog.level=ALL',
          '-Xmx1g',
          '--add-modules=ALL-SYSTEM',
          '--add-opens',
          'java.base/java.util=ALL-UNNAMED',
          '--add-opens',
          'java.base/java.lang=ALL-UNNAMED',
          '-jar',
          launcher_jar,
          '-configuration',
          config_path,
          '-data',
          workspace_dir,
        },
        root_dir = root_dir,
        capabilities = require('blink.cmp').get_lsp_capabilities(),
        on_attach = function(client, bufnr)
          local map = function(keys, func, desc)
            vim.keymap.set('n', keys, func, { buffer = bufnr, desc = 'LSP: ' .. desc })
          end
          map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
          map('<leader>rn', vim.lsp.buf.rename, 'Rename')
          map('gd', vim.lsp.buf.definition, 'Go to Definition')
          map('K', vim.lsp.buf.hover, 'Hover')
          map('<leader>f', function()
            vim.lsp.buf.format({ async = true })
          end, 'Format')

          jdtls.setup.add_commands()
        end,
        settings = {
          java = {
            configuration = { updateBuildConfiguration = 'interactive' },
            format = { enabled = true, settings = { profile = 'GoogleStyle' } },
            completion = { favorites = { 'org.junit.jupiter.api.Assertions.*', 'org.mockito.Mockito.*' } },
          },
        },
      }

      jdtls.start_or_attach(config)
    end

    -- Setup autocmd for Java files
    vim.api.nvim_create_autocmd('FileType', {
      pattern = 'java',
      callback = function()
        if vim.b.jdtls_setup_started then
          return
        end
        vim.b.jdtls_setup_started = true

        local clients = vim.lsp.get_clients({ bufnr = 0, name = 'jdtls' })
        if #clients > 0 then
          return
        end

        setup_jdtls()
      end,
    })
  end,
}
