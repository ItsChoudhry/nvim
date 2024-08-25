local M = {}
local builtin = require 'telescope.builtin'

local function augroup(name)
  return vim.api.nvim_create_augroup('user__' .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ 'FileType' }, {
  group = augroup 'cpp_commentstring',
  pattern = 'h,cpp',
  callback = function()
    vim.api.nvim_buf_set_option(0, 'commentstring', '// %s')
  end,
})
vim.keymap.set('n', '<leader>pv', vim.cmd.Ex)
vim.keymap.set('x', '<leader>p', [["_dP]])
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]])
vim.keymap.set('n', '<leader>Y', [["+Y]])
vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww tmux-sessionizer<CR>')

return M
