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

local function get_cmake_binary(target)
  -- Look in ./build/ directory relative to the current workspace
  local exe_path = vim.fn.getcwd() .. '/build/' .. target
  if vim.fn.filereadable(exe_path) == 1 then
    return exe_path
  else
    return vim.fn.input('Binary not found, enter path to executable: ', exe_path, 'file')
  end
end

local function setup_default_configurations()
  local dap = require 'dap'
  -- will work out how to auto setup cpp too in the future when I know the layout better
  -- local cpp_configuration = {
  --   {
  --     name = 'CMake: Launch',
  --     type = 'cppdbg',
  --     request = 'launch',
  --     program = function()
  --       return get_cmake_binary 'my_executable' -- Replace with your target name
  --     end,
  --     cwd = '${workspaceFolder}',
  --     stopOnEntry = false,
  --     args = {},
  --   },
  --   {
  --     name = 'CMake: Launch with args',
  --     type = 'cppdbg',
  --     request = 'launch',
  --     program = function()
  --       return get_cmake_binary 'my_executable'
  --     end,
  --     cwd = '${workspaceFolder}',
  --     stopOnEntry = false,
  --     args = function()
  --       local input = vim.fn.input 'Program arguments: '
  --       return vim.fn.split(input, ' ')
  --     end,
  --   },
  --   {
  --     name = 'Attach to gdbserver :1234',
  --     type = 'cppdbg',
  --     request = 'launch',
  --     MIMode = 'gdb',
  --     miDebuggerServerAddress = 'localhost:1234',
  --     miDebuggerPath = '/usr/bin/gdb',
  --     cwd = '${workspaceFolder}',
  --     program = function()
  --       return get_cmake_binary 'my_executable' -- Replace with your target name
  --     end,
  --   },
  -- }

  local cppdbg_configuration = {
    {
      name = 'Launch',
      type = 'cppdbg',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
    },
    {
      name = 'Launch with args',
      type = 'cppdbg',
      request = 'launch',
      program = function()
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = function()
        local input = vim.fn.input 'Program arguments: '
        return vim.fn.split(input, ' ')
      end,
    },
  }

  local rust_configuration = {
    {
      name = 'Rust: Launch',
      type = 'cppdbg',
      request = 'launch',
      program = function()
        local crate = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
        return vim.fn.getcwd() .. '/target/debug/' .. crate
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = {},
    },
    {
      name = 'Rust: Launch with args',
      type = 'cppdbg',
      request = 'launch',
      program = function()
        local crate = vim.fn.fnamemodify(vim.fn.getcwd(), ':t')
        return vim.fn.getcwd() .. '/target/debug/' .. crate
      end,
      cwd = '${workspaceFolder}',
      stopOnEntry = false,
      args = function()
        local input = vim.fn.input 'Program arguments: '
        return vim.fn.split(input, ' ')
      end,
    },
  }

  dap.configurations.c = cppdbg_configuration
  dap.configurations.cpp = cppdbg_configuration
  dap.configurations.asm = cppdbg_configuration
  dap.configurations.rust = rust_configuration

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

    dap.adapters.cppdbg = {
      id = 'cppdbg',
      type = 'executable',
      command = '/home/choudhry/.local/share/nvim/mason/bin/OpenDebugAD7',
    }
    vim.keymap.set('n', '<F5>', function()
      require('dap').continue()
    end)
  end,
}

