return {
  'mfussenegger/nvim-jdtls',
  ft = { 'java' },
  config = function()
    local jdtls = require('jdtls')
    local jdtls_setup = require('jdtls.setup')

    local function find_jdtls()
      local uv = vim.uv or vim.loop

      local function newest_file(files)
        local best, best_mtime

        for _, file in ipairs(files) do
          local stat = uv.fs_stat(file)
          local mtime = stat and stat.mtime or 0

          if not best_mtime or mtime > best_mtime then
            best = file
            best_mtime = mtime
          end
        end

        return best
      end

      local jar_patterns = {}

      if vim.env.JDTLS_HOME then
        table.insert(jar_patterns, vim.fn.expand(vim.env.JDTLS_HOME) .. '/plugins/org.eclipse.equinox.launcher_*.jar')
      end

      if vim.fn.executable('mise') == 1 then
        local ok, out = pcall(vim.fn.system, { 'mise', 'where', 'eclipse-jdtls' })

        if ok and vim.v.shell_error == 0 then
          local mise_path = vim.trim(out)

          if mise_path ~= '' then
            table.insert(jar_patterns, mise_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
          end
        end
      end

      local extra_patterns = {
        vim.fn.expand('~/.local/share/mise/installs/eclipse-jdtls/latest/plugins/org.eclipse.equinox.launcher_*.jar'),
        vim.fn.expand('~/.local/share/mise/installs/eclipse-jdtls/*/plugins/org.eclipse.equinox.launcher_*.jar'),
        vim.fn.stdpath('data') .. '/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar',
        '/opt/jdtls/plugins/org.eclipse.equinox.launcher_*.jar',
        '/usr/local/share/jdtls/plugins/org.eclipse.equinox.launcher_*.jar',
      }

      for _, pattern in ipairs(extra_patterns) do
        table.insert(jar_patterns, pattern)
      end

      for _, pattern in ipairs(jar_patterns) do
        local jars = vim.fn.glob(pattern, true, true)

        if #jars > 0 then
          local jar = newest_file(jars) or jars[1]
          local root = vim.fn.fnamemodify(jar, ':h:h')

          return root, jar
        end
      end
    end

    local jdtls_path, launcher_jar = find_jdtls()

    if not jdtls_path or not launcher_jar then
      vim.notify(
        'jdtls: could not find Eclipse JDT LS launcher jar. Set JDTLS_HOME or adjust find_jdtls().',
        vim.log.levels.ERROR
      )
      return
    end

    local config_path

    if vim.fn.has('linux') == 1 then
      config_path = jdtls_path .. '/config_linux'
    elseif vim.fn.has('macunix') == 1 then
      config_path = jdtls_path .. '/config_mac'
    elseif vim.fn.has('win32') == 1 then
      config_path = jdtls_path .. '/config_win'
    else
      vim.notify('Unsupported OS for jdtls', vim.log.levels.ERROR)
      return
    end

    if vim.fn.isdirectory(config_path) ~= 1 then
      vim.notify('jdtls: config directory not found: ' .. config_path, vim.log.levels.ERROR)
      return
    end

    local root_markers = {
      '.git',
      'mvnw',
      'gradlew',
      'pom.xml',
      'build.gradle',
      '.project',
    }

    local root_dir = jdtls_setup.find_root(root_markers)

    if not root_dir or root_dir == '' then
      return
    end

    local project_name = vim.fn.fnamemodify(root_dir, ':p:t')

    if project_name == '' then
      project_name = 'default'
    end

    local workspace_dir = vim.fn.stdpath('cache') .. '/jdtls/workspace/' .. project_name

    vim.fn.mkdir(workspace_dir, 'p')

    jdtls.start_or_attach({
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

      on_attach = function(_, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set('n', keys, func, {
            buffer = bufnr,
            desc = 'LSP: ' .. desc,
          })
        end

        map('<leader>ca', vim.lsp.buf.code_action, 'Code Action')
        map('<leader>rn', vim.lsp.buf.rename, 'Rename')
        map('gd', vim.lsp.buf.definition, 'Go to Definition')
        map('K', vim.lsp.buf.hover, 'Hover')

        map('<leader>f', function()
          vim.lsp.buf.format({ async = true })
        end, 'Format')

        jdtls_setup.add_commands()
      end,

      settings = {
        java = {
          --[[
          project = {
            sourcePaths = { '.' },
            outputPath = 'bin',
          },
          --]]
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
    })
  end,
}
