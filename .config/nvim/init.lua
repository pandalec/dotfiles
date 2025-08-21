-- Set nvim options
vim.diagnostic.config({ update_in_insert = true })
vim.g.have_nerd_font = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.clipboard = "unnamedplus" -- use system clipboard
vim.o.confirm = true
vim.o.cursorline = true
vim.o.lazyredraw = true -- fix ghostty mouse lags in nvim
vim.o.mouse = "a" -- enable mouse in all modes
vim.o.mousemoveevent = true -- enable mouse move events
vim.o.number = true
vim.o.relativenumber = true
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.o.signcolumn = "yes"
vim.o.swapfile = false
vim.o.tabstop = 2
vim.o.timeoutlen = 500 -- reduce timeout during keypresses
vim.o.undofile = true
vim.o.winborder = "rounded"
vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.opt.termguicolors = true

-- Highlight when yanking text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})

-- Add plugins via vim.pack (nvim 0.12+)
vim.pack.add({
	{ src = "https://github.com/Saghen/blink.cmp", version = "v1.6.0" }, -- try out another autocomplete
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" }, -- replace system lsp/linter installations
	{ src = "https://github.com/akinsho/toggleterm.nvim" }, -- enables scooter and terminal function
	{ src = "https://github.com/catppuccin/nvim" }, -- fav theme
	{ src = "https://github.com/gbprod/substitute.nvim" }, -- substitute commands
	{ src = "https://github.com/kdheepak/lazygit.nvim" }, -- enables lazygit
	{ src = "https://github.com/kylechui/nvim-surround" }, -- surround add, delete and replace
	{ src = "https://github.com/lewis6991/gitsigns.nvim.git" }, -- git changes in sign column
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" }, -- replace system lsp/linter installations
	{ src = "https://github.com/mason-org/mason.nvim" }, -- replace system lsp/linter installations
	{ src = "https://github.com/mg979/vim-visual-multi.git" }, -- add multi cursor support
	{ src = "https://github.com/mikavilpas/yazi.nvim" }, -- enables yazi file manager
	{ src = "https://github.com/neovim/nvim-lspconfig" }, -- default config for lsp's
	{ src = "https://github.com/numToStr/Comment.nvim" }, -- enables comment function
	{ src = "https://github.com/nvim-lua/plenary.nvim" }, -- dependency for yazi
	{ src = "https://github.com/nvim-telescope/telescope.nvim" }, -- fuzzy file, grep and buffer search
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" }, -- dependency for bufferline
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" }, -- treesitter
	{ src = "https://github.com/pandalec/gradle.nvim" }, -- my gradle plugin :)
	{ src = "https://github.com/rmagatti/auto-session" }, -- auto save and restore sessions
	{ src = "https://github.com/sschleemilch/slimline.nvim" }, -- slim statusline
	{ src = "https://github.com/stevearc/conform.nvim" }, -- add format
	{ src = "https://github.com/willothy/nvim-cokeline" }, -- custom bufferline
	{ src = "https://github.com/windwp/nvim-autopairs" }, -- autopairs for chars
})

-- Setup mason and auto install all dependencies
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"ansible-lint",
		"ansiblels",
		"bashls",
		"black", -- python format
		"cssls",
		"docker_compose_language_service",
		"docker_language_server",
		"dockerls",
		"fish_lsp",
		"groovyls",
		"helm_ls",
		"html",
		"jsonls",
		"kotlin-debug-adapter",
		"kotlin_language_server",
		"ktlint",
		"lua_ls",
		"marksman",
		"nginx-config-formatter",
		"nginx-language-server",
		"npm-groovy-lint",
		"prettier",
		"pyright",
		"rust_analyzer",
		"shfmt",
		"stylua",
		"systemd_ls",
		"terraform",
		"terraformls",
		"tree-sitter-cli",
		"yamlls",
	},
})

-- Setup lsp
vim.filetype.add({ -- Enable ansible lsp for yml files
	extension = {
		yml = function(_, bufnr)
			local path = vim.api.nvim_buf_get_name(bufnr)
			if path:match("playbooks/") or path:match("roles/.*/tasks/") then
				return "yaml.ansible"
			else
				return "yaml"
			end
		end,
		kts = "kotlin",
	},
})

vim.lsp.config("lua_ls", { -- Configure lua_ls that it wont show vim errors
	settings = {
		Lua = { diagnostics = { globals = { "vim" } }, telemetry = { enable = false } },
	},
})

vim.lsp.config("kotlin_language_server", { filetypes = { "kotlin", "kt", "kts" } }) -- Configure kotlin_language_server

-- Setup conform auto-formatter
require("conform").setup({
	formatters_by_ft = {
		ansible = { "prettier", "ansible-lint", stop_after_first = true },
		bash = { "shfmt" },
		css = { "prettier" },
		groovy = { "npm-groovy-lint" },
		helm = { "prettier" },
		html = { "prettier" },
		javascript = { "prettier" },
		json = { "prettier" },
		kotlin = { "ktlint" },
		lua = { "stylua" },
		markdown = { "prettier" },
		python = { "black" },
		rust = { "rustfmt" },
		toml = { "taplo" },
		terraform = { "terraform_fmt" },
		yaml = { "prettier" },
	},
	format_on_save = { timeout_ms = 5000, lsp_format = "fallback" },
})

-- Setup blink.cmp auto completion
require("blink.cmp").setup({
	signature = { enabled = true },
	keymap = {
		preset = "enter",
		["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
	},
	cmdline = {
		keymap = {
			["<Tab>"] = { "select_next", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },
			["<CR>"] = { "accept_and_enter", "fallback" },
		},
		completion = {
			menu = { auto_show = true },
			list = { selection = { preselect = false } },
		},
	},
	completion = {
		documentation = { auto_show = true, auto_show_delay_ms = 500 },
		menu = {
			auto_show = true,
			draw = {
				treesitter = { "lsp" },
				columns = { { "kind_icon", "label", "label_description", gap = 1 }, { "kind" } },
			},
		},
		list = { selection = { preselect = false, auto_insert = true } },
	},
})

-- Setup slimline status line
require("slimline").setup({
	style = "fg",
	bold = true,
	hl = { secondary = "Comment" },
	configs = {
		mode = {
			verbose = true,
			hl = {
				normal = "Type",
				visual = "Keyword",
				insert = "Function",
				replace = "Statement",
				command = "String",
				other = "Function",
			},
		},
		path = { hl = { primary = "Label" } },
		git = { hl = { primary = "Function" } },
		filetype_lsp = { hl = { primary = "String" } },
	},
})

-- Setup various plugins
require("Comment").setup()
require("cokeline").setup()
require("nvim-autopairs").setup({})
require("nvim-surround").setup({})
require("substitute").setup()
require("yazi").setup()

-- Setup catpuccin
require("catppuccin").setup({
	auto_integrations = true,
	flavour = "auto",
	background = { light = "latte", dark = "mocha" },
})
vim.cmd.colorscheme("catppuccin")

-- Setup lazygit
function EditLineFromLazygit(file_path, line)
	local path = vim.fn.expand("%:p")
	if path == file_path then
		vim.cmd(tostring(line))
	else
		vim.cmd("e " .. file_path)
		vim.cmd(tostring(line))
	end
end

function EditFromLazygit(file_path)
	local path = vim.fn.expand("%:p")
	if path == file_path then
		return
	else
		vim.cmd("e " .. file_path)
	end
end

-- Setup toggleterm
require("toggleterm").setup({
	shade_terminals = false,
	size = function(term)
		if term.direction == "horizontal" then
			return vim.o.lines * 0.5
		elseif term.direction == "vertical" then
			return vim.o.columns * 0.5
		end
	end,
	start_in_insert = true,
	hidden = true,
})

local Terminal = require("toggleterm.terminal").Terminal

local scooter = Terminal:new({ -- scooter terminal
	cmd = "scooter",
	direction = "float",
	float_opts = { border = "curved", title_pos = "center" },
	name = "scooter",
})

_G.ToggleScooter = function()
	scooter:toggle()
end

local floating_terminal = Terminal:new({ -- floating terminal
	direction = "float",
	float_opts = { border = "curved", title_pos = "center" },
	name = "floating_terminal",
})

_G.ToggleFloatingTerminal = function()
	floating_terminal:toggle()
end

local horizontal_terminal = Terminal:new({ -- horizontal terminal
	name = "terminal",
	direction = "horizontal",
})

_G.ToggleHorizontalTerminal = function()
	horizontal_terminal:toggle()
end

local vertical_terminal = Terminal:new({ -- vertical terminal
	name = "terminal",
	direction = "vertical",
})

_G.ToggleVerticalTerminal = function()
	vertical_terminal:toggle()
end

function _G.SetTerminalKeymaps() -- Configure terminal keymaps
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
	vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

vim.cmd("autocmd! TermOpen term://*toggleterm#* lua SetTerminalKeymaps()")

-- Setup telescope
require("telescope").setup({
	defaults = {
		layout_config = { horizontal = { width = { padding = 0 }, height = { padding = 0 } } },
		path_display = { "truncate" },
	},
})
require("telescope").load_extension("lazygit")

-- Setup auto session
require("auto-session").setup({
	suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
})

-- Setup gradle
require("gradle").setup({ keymaps = false, load_on_startup = true, disable_startup_notification = true })

-- Keymaps
local k = vim.keymap
k.set("", "<ScrollWheelDown>", "2<C-E>", { noremap = true, silent = true }) -- fix ghostty mouse lags in nvim
k.set("", "<ScrollWheelUp>", "2<C-Y>", { noremap = true, silent = true }) -- fix ghostty mouse lags in nvim
k.set("", "<Space>", "<Nop>", { desc = "Ignore space", silent = true, noremap = true }) -- hopefully fixing space as leader issue
k.set("", "<leader>c", ":echo 'Use commands...'<CR>")
k.set("n", "<A-Left>", "<Plug>(cokeline-focus-prev)", { desc = "Go to previous buffer" })
k.set("n", "<A-Right>", "<Plug>(cokeline-focus-next)", { desc = "Go to next buffer" })
k.set("n", "<A-S-Left>", "<Plug>(cokeline-switch-prev)", { desc = "Go to previous buffer" })
k.set("n", "<A-S-Right>", "<Plug>(cokeline-switch-next)", { desc = "Go to next buffer" })
k.set("n", "<A-S-h>", "<Plug>(cokeline-switch-prev)", { desc = "Go to previous buffer" })
k.set("n", "<A-S-l>", "<Plug>(cokeline-switch-next)", { desc = "Go to next buffer" })
k.set("n", "<A-h>", "<Plug>(cokeline-focus-prev)", { desc = "Go to previous buffer" })
k.set("n", "<A-l>", "<Plug>(cokeline-focus-next)", { desc = "Go to next buffer" })
k.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
k.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
k.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
k.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
k.set("n", "<leader>/", require("telescope.builtin").live_grep, { desc = "Live grep", noremap = true })
k.set("n", "<leader>D", vim.diagnostic.setloclist, { desc = "Open [D]iagnostic quickfix list" })
k.set("n", "<leader>GG", ":lua require('gradle').telescope.pick_tasks()<CR>", { silent = true })
k.set("n", "<leader>GR", ":lua require('gradle').tasks.refresh_tasks_async()<CR>", { silent = true })
k.set("n", "<leader>GW", ":lua require('gradle').terminal.toggle()<CR>", { silent = true })
k.set("n", "<leader>TH", ":lua ToggleHorizontalTerminal()<CR>", { silent = true, desc = "Toggle horizontal terminal" })
k.set("n", "<leader>TV", ":lua ToggleVerticalTerminal()<CR>", { silent = true, desc = "Toggle vertical terminal" })
k.set("n", "<leader>b", require("telescope.builtin").buffers, { desc = "Find buffers", noremap = true })
k.set("n", "<leader>e", ":Yazi<CR>")
k.set("n", "<leader>f", require("telescope.builtin").find_files, { desc = "Find files", noremap = true })
k.set("n", "<leader>g", ":LazyGit<CR>")
k.set("n", "<leader>o", ":update<CR> :source<CR>")
k.set("n", "<leader>q", ":bdelete<CR>")
k.set("n", "<leader>r", ":lua ToggleScooter()<CR>", { silent = true, desc = "Toogle Scooter" })
k.set("n", "<leader>t", ":lua ToggleFloatingTerminal()<CR>", { silent = true, desc = "Toggle floating terminal" })
k.set("n", "<leader>w", ":write<CR>")
k.set("n", "S", require("substitute").eol, { noremap = true })
k.set("n", "s", require("substitute").operator, { noremap = true })
k.set("n", "ss", require("substitute").line, { noremap = true })
k.set("v", "<A-Left>", "<Esc>:bprevious<CR>", { desc = "Go to previous buffer" })
k.set("v", "<A-Right>", "<Esc>:bnext<CR>", { desc = "Go to next buffer" })
k.set("v", "<A-h>", "<Esc>:bprevious<CR>", { desc = "Go to previous buffer" })
k.set("v", "<A-l>", "<Esc>:bnext<CR>", { desc = "Go to next buffer" })
k.set("v", "<leader>w", "<Esc>:write<CR>")
k.set("v", "H", "<gv", { desc = "Move line(s) to the left" })
k.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line(s) down" })
k.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line(s) up" })
k.set("v", "L", ">gv", { desc = "Move line(s) to the right" })
k.set("x", "s", require("substitute").visual, { noremap = true })
