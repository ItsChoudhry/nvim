-- return {
--   {
--     'nvim-lua/plenary.nvim', -- LazyVim already includes plenary, so this is just a placeholder
--     config = function()
--       vim.api.nvim_create_autocmd('FileType', {
--         -- pattern = { "c", "cpp", "javascript", "typescript" }, -- Adjust filetypes as needed
--         callback = function()
--           vim.opt_local.formatoptions:remove 'r'
--         end,
--       })
--     end,
--   },
-- }
return {
  {
    'nvim-lua/plenary.nvim',
    config = function()
      vim.opt.formatoptions:remove 'r'
    end,
  },
}
