return {
  {
    'theHamsta/nvim-dap-virtual-text',
    config = function()
      require('nvim-dap-virtual-text').setup({
        virt_text_pos = 'eol',
        highlight_changed_variables = false,
        all_frames = true,
        commented = true,
      })
    end,
  },
  {
    'mfussenegger/nvim-dap',
    event = 'VeryLazy',
    dependencies = {
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      'theHamsta/nvim-dap-virtual-text',
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')
      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
      vim.fn.sign_define(
        'DapBreakpointCondition',
        { text = '', texthl = 'DapBreakpointCondition', linehl = '', numhl = '' }
      )
      vim.fn.sign_define(
        'DapBreakpointRejected',
        { text = '', texthl = 'DapBreakpointRejected', linehl = '', numhl = '' }
      )
      vim.fn.sign_define('DapLogPoint', { text = '', texthl = 'DapLogPoint', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped', linehl = '', numhl = '' })
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { fg = '#e06c75' })
      vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { fg = '#e5c07b' })
      vim.api.nvim_set_hl(0, 'DapBreakpointRejected', { fg = '#e06c75' })
      vim.api.nvim_set_hl(0, 'DapLogPoint', { fg = '#61afef' })
      vim.api.nvim_set_hl(0, 'DapStopped', { fg = '#98c379' })

      dapui.setup({
        layouts = {
          {
            elements = {
              { id = 'scopes', size = 0.55 },
              { id = 'stacks', size = 0.45 },
            },
            position = 'right',
            size = 35,
          },
          {
            elements = {
              { id = 'console', size = 0.6 },
              { id = 'repl', size = 0.4 },
            },
            position = 'bottom',
            size = 8,
          },
        },
        floating = {
          max_height = 0.8,
          max_width = 0.8,
          border = 'rounded',
        },
      })

      -- Auto-open UI when debugging starts
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
      dap.adapters.lldb = {
        type = 'executable',
        command = 'lldb-dap',
        name = 'lldb',
      }

      local lldb = {
        name = 'Launch lldb',
        type = 'lldb',
        request = 'launch',
        program = function()
          return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
        end,
        cwd = '${workspaceFolder}',
        stopOnEntry = false,
        args = {},
        runInTerminal = false,
      }
      dap.configurations.c = {
        lldb,
      }
      dap.configurations.cpp = dap.configurations.c
    end,
  },
}
