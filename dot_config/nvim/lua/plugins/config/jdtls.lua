local function setup_jdtls()
  local jdtls = require('jdtls')

  local mason_path = vim.fn.stdpath('data') .. '/mason'
  local jdtls_path = mason_path .. '/packages/jdtls'

  local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
  local config_path = jdtls_path .. '/config_linux'

  local root_markers = { '.git', 'mvnw', 'gradlew', 'pom.xml', 'build.gradle', '.project' }
  local root_dir = require('jdtls.setup').find_root(root_markers)

  if root_dir == '' then
    vim.notify('No Java project detected. jdtls not starting.', vim.log.levels.INFO)
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
      vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { buffer = bufnr })
      vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { buffer = bufnr })
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { buffer = bufnr })
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = bufnr })
      vim.keymap.set('n', '<leader>f', function()
        vim.lsp.buf.format({ async = true })
      end, { buffer = bufnr })
      jdtls.setup.add_commands()
    end,
    settings = {
      java = {
        configuration = {
          updateBuildConfiguration = 'interactive',
          checkProjectSettingsExclusions = true,
        },
        eclipse = {
          preferences = {
            'org.eclipse.jdt.core.projectNonJavaProjectSupport=true',
            'org.eclipse.jdt.core.compiler.problem.unclosedCloseable=ignore',
            'org.eclipse.jdt.core.compiler.problem.unusedWarningToken=ignore',
            'org.eclipse.jdt.core.compiler.problem.missingJavadocComments=ignore',
          },
        },
        sources = {
          directories = {
            'src/main/java',
            'src',
            '.',
          },
        },
        format = {
          enabled = true,
          settings = {
            profile = 'GoogleStyle',
          },
        },
        runtime = {},
        completion = {
          favorites = {
            'org.junit.jupiter.api.Assertions.*',
            'org.mockito.Mockito.*',
          },
        },
        codeGeneration = {
          toString = {
            template = '${object.className}{${member.name()}=${member.value}, ${otherMembers}}',
          },
        },
        project = {
          referencedLibraries = {},
        },
      },
    },
    init_options = {
      bundles = {},
      extendedClientCapabilities = {
        progressReportProvider = true,
        classFileContentsSupport = true,
      },
    },
  }

  jdtls.start_or_attach(config)
end

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'java',
  callback = function()
    setup_jdtls()
  end,
})
