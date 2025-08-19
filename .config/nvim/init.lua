-- Set nvim options
vim.diagnostic.config({ update_in_insert = true })
vim.g.have_nerd_font = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.clipboard = "unnamedplus" -- use system clipboard
vim.o.confirm = true
vim.o.cursorline = true
-- vim.o.mouse = "a" -- enable mouse in all modes
vim.o.mousemoveevent = true -- enable mouse move events
vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.swapfile = false
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.timeoutlen = 500 -- reduce timeout during keypresses
vim.o.undofile = true
vim.o.winborder = "rounded"
vim.opt.completeopt = { "menuone", "noselect", "popup" }
vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"

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
	{ src = "https://github.com/akinsho/bufferline.nvim.git" }, -- custom bufferline
	{ src = "https://github.com/akinsho/toggleterm.nvim.git" }, -- enables scooter and terminal function
	{ src = "https://github.com/catppuccin/nvim.git" }, -- fav theme
	{ src = "https://github.com/gbprod/substitute.nvim.git" }, -- substitute commands
	{ src = "https://github.com/kdheepak/lazygit.nvim.git" }, -- enables lazygit
	{ src = "https://github.com/kylechui/nvim-surround.git" }, -- surround add, delete and replace
	{ src = "https://github.com/mikavilpas/yazi.nvim" }, -- enables yazi file manager
	{ src = "https://github.com/neovim/nvim-lspconfig" }, -- default config for lsp's
	{ src = "https://github.com/numToStr/Comment.nvim.git" }, -- enables comment function
	{ src = "https://github.com/nvim-lua/plenary.nvim" }, -- dependency for yazi
	{ src = "https://github.com/nvim-telescope/telescope.nvim.git" }, -- fuzzy file, grep and buffer search
	{ src = "https://github.com/nvim-tree/nvim-web-devicons.git" }, -- dependency for bufferline
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" }, -- treesitter
	{ src = "https://github.com/pandalec/gradle.nvim" }, -- my gradle plugin :)
	{ src = "https://github.com/rmagatti/auto-session.git" }, -- auto save and restore sessions
	{ src = "https://github.com/sschleemilch/slimline.nvim.git" }, -- slim statusline
	{ src = "https://github.com/stevearc/conform.nvim.git" }, -- add format
	{ src = "https://github.com/windwp/nvim-autopairs" }, -- autopairs for chars
	{ src = "https://github.com/Saghen/blink.cmp", version = "v1.6.0" }, -- try out another autocomplete
	{ src = "https://github.com/mason-org/mason.nvim" }, -- replace system lsp/linter installations
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" }, -- replace system lsp/linter installations
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" }, -- replace system lsp/linter installations
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

-- Enable ansible lsp for yml files
vim.filetype.add({
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

-- Configure auto-formatter on save
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
	format_on_save = {
		timeout_ms = 5000,
		lsp_format = "fallback",
	},
})

-- Enable auto completion
require("blink.cmp").setup({
	signature = { enabled = true },
	keymap = {
		preset = "enter",
		["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
	},
	cmdline = {
		keymap = { preset = "inherit" },
		completion = { menu = { auto_show = true } },
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
		list = {
			selection = { preselect = false, auto_insert = true },
		},
	},
})

-- Configure lua_ls that it wont show vim errors
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
			telemetry = {
				enable = false,
			},
		},
	},
})

-- Configure kotlin_language_server for kts and kt files
vim.lsp.config("kotlin_language_server", {
	filetypes = { "kotlin", "kt", "kts" },
})

-- Setup slimline
require("slimline").setup({
	style = "fg",
	bold = true,
	hl = {
		secondary = "Comment",
	},
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
		path = {
			hl = {
				primary = "Label",
			},
		},
		git = {
			hl = {
				primary = "Function",
			},
		},
		filetype_lsp = {
			hl = {
				primary = "String",
			},
		},
	},
})

-- Setup bufferline
require("bufferline").setup({
	options = {
		style_preset = {
			require("bufferline").style_preset.no_italic,
		},
		indicator = {
			style = "none",
		},
		diagnostics = "nvim_lsp",
		diagnostics_indicator = function(count, level, diagnostics_dict, context)
			local s = ""
			for e, n in pairs(diagnostics_dict) do
				local sym = e == "error" and "" or (e == "warning" and "" or "")
				s = s .. n .. sym
			end
			return s
		end,
		show_tab_indicators = false,
		middle_mouse_command = "bdelete! %d",
		separator_style = { "", "" },
		right_mouse_command = "vertical sbuffer %d",
		persist_buffer_sort = true,
		hover = {
			enabled = true,
			delay = 200,
			reveal = { "close" },
		},
	},
})

-- Setup various plugins
require("nvim-autopairs").setup({})
require("yazi").setup()
require("nvim-surround").setup({})
require("Comment").setup()
require("catppuccin").setup({
	flavour = "auto",
	background = {
		light = "latte",
		dark = "mocha",
	},
	-- transparent_background = true, -- disables setting the background color.
})
vim.cmd("colorscheme catppuccin")

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
})

local Terminal = require("toggleterm.terminal").Terminal

-- scooter terminal
local scooter = Terminal:new({
	cmd = "scooter",
	direction = "float",
	float_opts = { border = "curved", title_pos = "center" },
	name = "scooter",
	hidden = true,
	start_in_insert = true,
})

_G.ToggleScooter = function()
	scooter:toggle()
end

-- floating terminal
local floating_terminal = Terminal:new({
	direction = "float",
	float_opts = { border = "curved", title_pos = "center" },
	name = "floating_terminal",
	hidden = true,
	start_in_insert = true,
})

_G.ToggleFloatingTerminal = function()
	floating_terminal:toggle()
end

-- horizontal terminal
local horizontal_terminal = Terminal:new({
	name = "terminal",
	direction = "horizontal",
	hidden = true,
	start_in_insert = true,
})

_G.ToggleHorizontalTerminal = function()
	horizontal_terminal:toggle()
end

-- vertical terminal
local vertical_terminal = Terminal:new({
	name = "terminal",
	direction = "vertical",
	hidden = true,
	start_in_insert = true,
})

_G.ToggleVerticalTerminal = function()
	vertical_terminal:toggle()
end

function _G.set_terminal_keymaps()
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<esc><esc>", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "jk", [[<C-\><C-n>]], opts)
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
	vim.keymap.set("t", "<C-w>", [[<C-\><C-n><C-w>]], opts)
end

vim.cmd("autocmd! TermOpen term://*toggleterm#* lua set_terminal_keymaps()")

-- Setup telescope
require("telescope").setup({
	defaults = {
		layout_config = {
			-- vertical = { -- doesnt work
			-- 	width = { padding = 0 },
			-- },
			horizontal = {
				width = { padding = 0 },
			},
		},
		path_display = {
			"truncate",
		},
	},
})

-- Setup substitute
require("substitute").setup()

-- Setup auto session
require("auto-session").setup({
	suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
})

-- Setup gradle
require("gradle").setup({
	keymaps = false,
	load_on_startup = true,
	disable_startup_notification = true,
})

-- Keymaps
vim.keymap.set("n", "<A-Left>", ":bprevious<CR>", { desc = "Go to previous buffer" })
vim.keymap.set("n", "<A-Right>", ":bnext<CR>", { desc = "Go to next buffer" })
vim.keymap.set("n", "<A-h>", ":bprevious<CR>", { desc = "Go to previous buffer" })
vim.keymap.set("n", "<A-l>", ":bnext<CR>", { desc = "Go to next buffer" })
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set("n", "<leader>/", require("telescope.builtin").live_grep, { desc = "Live grep", noremap = true })
vim.keymap.set("n", "<leader>D", vim.diagnostic.setloclist, { desc = "Open [D]iagnostic quickfix list" })
vim.keymap.set("n", "<leader>GG", ":lua require('gradle').telescope.pick_tasks()<CR>", { silent = true })
vim.keymap.set("n", "<leader>GR", ":lua require('gradle').tasks.refresh_tasks_async()<CR>", { silent = true })
vim.keymap.set("n", "<leader>GW", ":lua require('gradle').terminal.toggle()<CR>", { silent = true })
vim.keymap.set("n", "<leader>TH", ":lua ToggleHorizontalTerminal()<CR>", { silent = true, desc = "== terminal" })
vim.keymap.set("n", "<leader>TV", ":lua ToggleVerticalTerminal()<CR>", { silent = true, desc = "|| terminal" })
vim.keymap.set("n", "<leader>b", require("telescope.builtin").buffers, { desc = "Find buffers", noremap = true })
vim.keymap.set("n", "<leader>c", require("Comment.api").toggle.linewise.current, { silent = true, desc = "Line" })
vim.keymap.set("n", "<leader>e", ":Yazi<CR>")
vim.keymap.set("n", "<leader>f", require("telescope.builtin").find_files, { desc = "Find files", noremap = true })
vim.keymap.set("n", "<leader>g", ":LazyGit<CR>")
vim.keymap.set("n", "<leader>o", ":update<CR> :source<CR>")
vim.keymap.set("n", "<leader>q", ":bdelete<CR>")
vim.keymap.set("n", "<leader>r", ":lua ToggleScooter()<CR>", { silent = true, desc = "Scooter" })
vim.keymap.set("n", "<leader>t", ":lua ToggleFloatingTerminal()<CR>", { silent = true, desc = "Floating terminal" })
vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "S", require("substitute").eol, { noremap = true })
vim.keymap.set("n", "s", require("substitute").operator, { noremap = true })
vim.keymap.set("n", "ss", require("substitute").line, { noremap = true })
vim.keymap.set("v", "<A-Left>", "<Esc>:bprevious<CR>", { desc = "Go to previous buffer" })
vim.keymap.set("v", "<A-Right>", "<Esc>:bnext<CR>", { desc = "Go to next buffer" })
vim.keymap.set("v", "<A-h>", "<Esc>:bprevious<CR>", { desc = "Go to previous buffer" })
vim.keymap.set("v", "<A-l>", "<Esc>:bnext<CR>", { desc = "Go to next buffer" })
vim.keymap.set("v", "<leader>C", "<Plug>(comment_toggle_blockwise_visual)gv", { silent = true, desc = "Block" })
vim.keymap.set("v", "<leader>c", "<Plug>(comment_toggle_linewise_visual)gv", { silent = true, desc = "Selection" })
vim.keymap.set("v", "<leader>w", "<Esc>:write<CR>")
vim.keymap.set("v", "H", "<gv", { desc = "Move line(s) to the left" })
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line(s) down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line(s) up" })
vim.keymap.set("v", "L", ">gv", { desc = "Move line(s) to the right" })
vim.keymap.set("x", "s", require("substitute").visual, { noremap = true })
vim.keymap.set({ "n", "v" }, " ", "<Nop>", { desc = "Ignore space", silent = true }) -- hopefully fixing space as leader issue
