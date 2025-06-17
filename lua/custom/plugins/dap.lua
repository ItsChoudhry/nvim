local function define_colors()
  vim.api.nvim_set_hl(0, 'DapBreakpoint', { ctermbg = 0, fg = '#b91c1c' })
  vim.api.nvim_set_hl(0, 'DapLogPoint', { ctermbg = 0, fg = '#61afef' })
  vim.api.nvim_set_hl(0, 'DapStopped', { ctermbg = 0, fg = '#98c379', bold = true })

  vim.fn.sign_define('DapBreakpoint', {
    text = '🔴',
    numhl = 'DapBreakpoint',
  })
  vim.fn.sign_define('DapBreakpointCondition', {
    text = '🔴',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint',
  })
  vim.fn.sign_define('DapBreakpointRejected', {
    text = '🔘',
    linehl = 'DapBreakpoint',
    numhl = 'DapBreakpoint',
  })
  vim.fn.sign_define('DapStopped', {
    text = '🟢',
    linehl = 'DapStopped',
    numhl = 'DapStopped',
  })
  vim.fn.sign_define('DapLogPoint', {
    text = '🟣',
    linehl = 'DapLogPoint',
    numhl = 'DapLogPoint',
  })
end

local function setup_default_configurations()
  local dap = require 'dap'
  local codelldb_configuration = {
    {
      name = 'Launch',
      type = 'codelldb',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
    },
  }

  dap.configurations.c = codelldb_configuration
  dap.configurations.cpp = codelldb_configuration
  dap.configurations.asm = codelldb_configuration

  require('dap-python').setup 'python3'
  table.insert(require('dap').configurations.python, {
    type = 'python',
    request = 'launch',
    name = 'module',
    module = vim.fn.fnamemodify(vim.fn.getcwd(), ':t'),
  })
  table.insert(require('dap').configurations.python, {
    type = 'python',
    request = 'launch',
    name = 'module:args',
    module = vim.fn.fnamemodify(vim.fn.getcwd(), ':t'),
    args = function()
      local args_string = vim.fn.input 'Arguments: '
      local utils = require 'dap.utils'
      if utils.splitstr and vim.fn.has 'nvim-0.10' == 1 then
        return utils.splitstr(args_string)
      end
      return vim.split(args_string, ' +')
    end,
  })
end

return {
  'mfussenegger/nvim-dap',
  dependencies = {
    {
      'nvim-telescope/telescope-dap.nvim',
      config = function()
        require('telescope').load_extension 'dap'
      end,
    },
    {
      'rcarriga/nvim-dap-ui',
      types = true,
    },
    'nvim-neotest/nvim-nio',
    {
      'theHamsta/nvim-dap-virtual-text',
      opts = {
        enabled = true,
      },
    },
    'jay-babu/mason-nvim-dap.nvim',
    'mfussenegger/nvim-dap-python',
    'folke/edgy.nvim',
  },
  config = function()
    setup_default_configurations()
    local dap = require 'dap'
    local dapui = require 'dapui'
    dapui.setup()

    dap.listeners.after.event_initialized['dapui_config'] = function()
      dapui.open()
      require('edgy').close()
    end
    dap.listeners.before.event_terminated['dapui_config'] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited['dapui_config'] = function()
      dapui.close()
    end

    define_colors()
    vim.keymap.set('n', '<F6>', function()
      dap.step_over()
    end)
    vim.keymap.set('n', '<F7>', function()
      dap.step_into()
    end)
    vim.keymap.set('n', '<F8>', function()
      dap.step_out()
    end)
    vim.keymap.set('n', '<leader>b', function()
      dap.toggle_breakpoint()
    end)
    vim.keymap.set('n', '<F10>', function()
      dap.terminate()
    end)

    dap.adapters.codelldb = {
      type = 'executable',
      command = '/home/choudhry/.local/share/nvim/mason/bin/codelldb',
      name = 'codelldb',
    }

    vim.keymap.set('n', '<F5>', function()
      require('dap').continue()
    end)
  end,
}
