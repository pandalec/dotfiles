vim.pack.add({
  { src = "https://github.com/rmagatti/auto-session" },
})

-- Setup auto session
require("auto-session").setup({
  suppressed_dirs = { "~/", "~/Documents", "~/Downloads", "/" },
})
