local dap = require('dap')
local dapui = require('dapui')
local osv = require('osv')

vim.keymap.set('n', '<leader>Db', dap.toggle_breakpoint)
vim.keymap.set('n', '<leader>Dc', dap.continue)
vim.keymap.set('n', '<leader>Dd', dap.down)
vim.keymap.set('n', '<leader>Dn', dap.step_over)
vim.keymap.set('n', '<leader>Dr', dap.repl.open)
vim.keymap.set('n', '<leader>Ds', dap.step_into)
vim.keymap.set('n', '<leader>Du', dap.up)
vim.keymap.set('n', '<leader>Dv', osv.launch)

dap.adapters.cppdbg = {
  id = 'cppdbg',
  type = 'executable',
  command = 'OpenDebugAD7',
}
dap.configurations.cpp = {
  {
    name = 'Launch file',
    type = 'cppdbg',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = function()
      return vim.fn.split(vim.fn.input('Arguments: ', '', 'file'), ' \\+')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = true,
    miDebuggerPath = 'lldb-mi',
  },
}

dap.configurations.lua = {
  {
    type = 'nlua',
    request = 'attach',
    name = 'Attach to running Neovim instance',
    host = function()
      local value = vim.fn.input('Host [127.0.0.1]: ')
      if value ~= '' then
        return value
      end
      return '127.0.0.1'
    end,
    port = function()
      local val = tonumber(vim.fn.input('Port: '))
      assert(val, 'Please provide a port number')
      return val
    end,
  }
}

dap.adapters.nlua = function(callback, config)
  callback({ type = 'server', host = config.host, port = config.port })
end

dapui.setup{}
dap.listeners.after.event_initialized['dapui_config'] = function() dapui.open() end
dap.listeners.before.event_terminated['dapui_config'] = function() dapui.close() end
dap.listeners.before.event_exited['dapui_config'] = function() dapui.close() end
