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

-- Move macro recording message to extui's box
vim.api.nvim_create_autocmd({ "RecordingEnter", "RecordingLeave" }, {
  callback = function(args)
    local reg = vim.fn.reg_recording() -- get the current recording register
    if args.event == "RecordingEnter" then
      vim.notify("Recording @" .. reg, vim.log.levels.INFO, { timeout = 1000 })
    else
      vim.notify("Stopped recording @" .. reg, vim.log.levels.INFO, { timeout = 500 })
    end
  end,
})

-- Avoid excessive redraws for large buffers
vim.api.nvim_create_autocmd("WinScrolled", {
  callback = function()
    vim.cmd("redraw") -- minimal redraw
  end,
})
