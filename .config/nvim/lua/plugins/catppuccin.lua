vim.pack.add({
  { src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
})

-- Setup catpuccin
require("catppuccin").setup({
  auto_integrations = true,
  transparent_background = true,
  flavour = "auto",
  background = { light = "latte", dark = "mocha" },
  custom_highlights = function(colors)
    return { -- use nvim bg for floats
      NormalFloat = { bg = colors.base },
      FloatBorder = { bg = colors.base },
      FloatTitle = { bg = colors.base },
    }
  end,
})
vim.cmd.colorscheme("catppuccin")
