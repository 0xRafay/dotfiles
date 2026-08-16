return {
  'nvim-java/nvim-java',
  ft = { 'java' },
  dependencies = {
    'neovim/nvim-lspconfig',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('java').setup({
      checks = {
        nvim_version = true, -- Check Neovim version
        nvim_jdtls_conflict = true, -- Check for nvim-jdtls conflict
      },

      -- JDTLS configuration
      jdtls = {
        enable = true,
        -- version = '1.43.0',
        path = vim.fn.expand('~/.local/share/mise/installs/eclipse-jdtls/latest'),
        -- auto_install = true,
      },

      -- Extensions
      lombok = {
        enable = true,
        version = '1.18.46',
        path = nil,
        auto_install = true,
      },

      java_test = {
        enable = false,
        version = '0.40.1',
        path = nil,
        auto_install = false,
      },

      java_debug_adapter = {
        enable = true,
        version = '0.58.2',
        path = nil,
        auto_install = true,
      },

      spring_boot_tools = {
        enable = true,
        version = '1.55.1',
        path = nil,
        auto_install = true,
      },

      -- JDK installation
      jdk = {
        enable = true,
        -- auto_install = true,
        -- version = '17',
        path = '/usr/lib/jvm/java-25-openjdk',
      },

      -- Logging
      log = {
        use_console = true,
        use_file = true,
        level = 'info',
        log_file = vim.fn.stdpath('state') .. '/nvim-java.log',
        max_lines = 1000,
        show_location = false,
      },
    })
    vim.lsp.enable('jdtls')
  end,
}
