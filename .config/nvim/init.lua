require("core.autocmds")
require("core.globals")
require("core.keymaps")
require("core.lsp")
require("core.options")
require("core.extui")

require("plugins.telescope") -- depends on plenary
require("plugins.toggleterm")

require("plugins.auto-session")
require("plugins.blink-cmp")
require("plugins.catppuccin")
require("plugins.comment")
require("plugins.conform")
require("plugins.gitsigns")
require("plugins.gradle") -- depends on telescope & toggleterm
require("plugins.jiratui") -- depends on telescope & toggleterm
require("plugins.mini-surround")
require("plugins.nvim-autopairs")
require("plugins.nvim-cokeline") -- depends on plenary
require("plugins.slimline")
require("plugins.substitute")
require("plugins.vim-visual-multi")
require("plugins.which-key")
