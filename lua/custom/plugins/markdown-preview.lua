return {
  'iamcco/markdown-preview.nvim',
  cmd = { 'MarkdownPreviewToggle', 'MarkdownPreview', 'MarkdownPreviewStop' },
  build = 'cd app && npm install',
  init = function()
    vim.g.mkdp_filetypes = { 'markdown' }
  end,
  config = function()
    vim.keymap.set('n', '<Leader>mpt', '<Plug>MarkdownPreviewToggle', { desc = 'Markdown Preview' })
  end,
  ft = { 'markdown' },
}
