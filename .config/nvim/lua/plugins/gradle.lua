vim.pack.add({
  { src = "https://github.com/pandalec/gradle.nvim" },
})

-- Setup gradle
require("gradle").setup({
  keymaps = false,
  load_on_startup = true,
  disable_startup_notification = true,
  floating_terminal_opts = FloatingTerminalOpts,
})
