return {
  'mfussenegger/nvim-jdtls',
  ft = { 'java' },
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'saghen/blink.cmp',
  },

  config = function()
    local jdtls = require('jdtls')

    local function setup_jdtls()
      local jdtls_path = vim.fn.stdpath('data') .. '/mason/packages/jdtls'

      local launcher_jars = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar', false, true)

      local launcher_jar = launcher_jars and launcher_jars[1] or ''

      if launcher_jar == '' then
        vim.notify('jdtls launcher jar not found', vim.log.levels.ERROR)
        return false
      end

      local config_path
      if vim.fn.has('linux') == 1 then
        config_path = jdtls_path .. '/config_linux'
      elseif vim.fn.has('mac') == 1 then
        config_path = jdtls_path .. '/config_mac'
      elseif vim.fn.has('win32') == 1 then
        config_path = jdtls_path .. '/config_win'
      else
        vim.notify('Unsupported OS for jdtls', vim.log.levels.ERROR)
        return false
      end

      local root_markers = {
        '.git',
        'mvnw',
        'gradlew',
        'pom.xml',
        'build.gradle',
        '.project',
      }

      local root_dir = require('jdtls.setup').find_root(root_markers)

      if not root_dir or root_dir == '' then
        return false
      end

      local project_name = vim.fs.basename(root_dir)
      local workspace_dir = vim.fn.stdpath('cache') .. '/jdtls/workspace/' .. project_name

      vim.fn.mkdir(workspace_dir, 'p')

      local config = {
        cmd = {
          'java',
          '-Declipse.application=org.eclipse.jdt.ls.core.id1',
          '-Dosgi.bundles.defaultStartLevel=4',
          '-Declipse.product=org.eclipse.jdt.ls.core.product',
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

        settings = {
          java = {
            project = {
              sourcePaths = { '.' },
            },
            configuration = {
              updateBuildConfiguration = 'interactive',
            },
            format = {
              enabled = true,
              settings = {
                profile = 'GoogleStyle',
              },
            },
            completion = {
              favorites = {
                'org.junit.jupiter.api.Assertions.*',
                'org.mockito.Mockito.*',
              },
            },
          },
        },
      }

      jdtls.start_or_attach(config)
      return true
    end

    local group = vim.api.nvim_create_augroup('UserJdtls', { clear = true })

    vim.api.nvim_create_autocmd('FileType', {
      group = group,
      pattern = 'java',
      callback = function()
        if vim.b.jdtls_setup_started then
          return
        end

        if setup_jdtls() then
          vim.b.jdtls_setup_started = true
        end
      end,
    })

    if vim.bo.filetype == 'java' and not vim.b.jdtls_setup_started then
      if setup_jdtls() then
        vim.b.jdtls_setup_started = true
      end
    end
  end,
}
