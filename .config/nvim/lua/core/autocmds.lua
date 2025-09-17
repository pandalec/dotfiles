-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function() vim.hl.on_yank() end,
})

-- Enable spell only for text files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "markdown", "text", "tex", "gitcommit", "asciidoc", "rst" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "de", "en_us" }
  end,
})
