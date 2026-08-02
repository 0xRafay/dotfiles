local function setup_jdtls()
  local jdtls = require('jdtls')

  local mason_path = vim.fn.stdpath('data') .. '/mason'
  local jdtls_path = mason_path .. '/packages/jdtls'

  local launcher_jar = vim.fn.glob(jdtls_path .. '/plugins/org.eclipse.equinox.launcher_*.jar')
  -- Adjust 'config_linux' to 'config_mac' or 'config_win' if needed
  local config_path = jdtls_path .. '/config_linux'

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

      -- adds :JdtCompile, :JdtOrganizeImports, etc.
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

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'java',
  callback = function()
    -- prevenets filetype fires multiple times rapidly
    if vim.b.jdtls_setup_started then
      return
    end
    vim.b.jdtls_setup_started = true

    -- prevent attaching if jdtls is already active for this buffer
    local clients = vim.lsp.get_clients({ bufnr = 0, name = 'jdtls' })
    if #clients > 0 then
      return
    end

    setup_jdtls()
  end,
})
