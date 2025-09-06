-- Set nvim options
vim.diagnostic.config({ update_in_insert = true, virtual_text = true })
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
	callback = function() vim.hl.on_yank() end,
})

-- Add plugins via vim.pack (nvim 0.12+)
vim.pack.add({
	{ src = "https://github.com/Saghen/blink.cmp", version = "v1.6.0" }, -- autocomplete
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" }, -- replace arch lsp/linter installations
	{ src = "https://github.com/akinsho/toggleterm.nvim" }, -- enables terminal functions
	{ src = "https://github.com/catppuccin/nvim" }, -- fav theme
	{ src = "https://github.com/gbprod/substitute.nvim" }, -- substitute commands
	{ src = "https://github.com/kylechui/nvim-surround" }, -- surround add, delete and replace
	{ src = "https://github.com/lewis6991/gitsigns.nvim.git" }, -- git changes in sign column
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" }, -- replace arch lsp/linter installations
	{ src = "https://github.com/mason-org/mason.nvim" }, -- replace arch lsp/linter installations
	{ src = "https://github.com/mg979/vim-visual-multi.git" }, -- add multi cursor support
	{ src = "https://github.com/neovim/nvim-lspconfig" }, -- default config for lsp
	{ src = "https://github.com/numToStr/Comment.nvim" }, -- enables comment function
	{ src = "https://github.com/nvim-lua/plenary.nvim" }, -- dependency for telescope
	{ src = "https://github.com/nvim-telescope/telescope.nvim" }, -- fuzzy file, grep and buffer search
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" }, -- dependency for bufferline
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" }, -- treesitter
	{ src = "https://github.com/pandalec/gradle.nvim" }, -- my gradle plugin :)
	{ src = "https://github.com/rmagatti/auto-session" }, -- auto save and restore sessions
	{ src = "https://github.com/sschleemilch/slimline.nvim" }, -- slim statusline
	{ src = "https://github.com/stevearc/conform.nvim" }, -- add auto formatter
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
		"codespell",
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
vim.filetype.add({
	pattern = {
		[".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
		[".*/roles/.+/handlers/.*%.ya?ml"] = "yaml.ansible",
		[".*/roles/.+/tasks/.*%.ya?ml"] = "yaml.ansible",
	},
	extension = {
		kts = "kotlin",
	},
})

vim.lsp.config("lua_ls", { -- Configure lua_ls that it won't show vim errors
	settings = {
		Lua = { diagnostics = { globals = { "vim" } }, telemetry = { enable = false } },
	},
})

vim.lsp.config("kotlin_language_server", { filetypes = { "kotlin", "kt", "kts" } }) -- Configure kotlin_language_server

-- Setup conform auto-formatter
require("conform").setup({
	formatters_by_ft = {
		["*"] = { "codespell" },
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
		terraform = { "terraform_fmt" },
		toml = { "taplo" },
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
require("nvim-autopairs").setup({})
require("nvim-surround").setup({})
require("substitute").setup()

-- Setup cokeline
-- Hide ToggleTerm float if active, then switch buffer
local function safe_buffer_switch(bufnr)
	local win = vim.api.nvim_get_current_win()
	local cfg = vim.api.nvim_win_get_config(win)

	-- If current window is floating
	if cfg.relative ~= "" then
		-- If it’s a toggleterm terminal, hide it
		if vim.bo.buftype == "terminal" then
			local ok, Terminal = pcall(require, "toggleterm.terminal")
			if ok then
				local term = Terminal.get_or_create_term({ bufnr = vim.api.nvim_get_current_buf() })
				if term and term:is_open() then term:toggle() end
			end
		end

		-- Redirect focus to the first non-floating window
		for _, w in ipairs(vim.api.nvim_list_wins()) do
			local wc = vim.api.nvim_win_get_config(w)
			if wc.relative == "" then
				vim.api.nvim_set_current_win(w)
				break
			end
		end
	end

	-- Finally, switch to the buffer
	vim.api.nvim_set_current_buf(bufnr)
end

local get_hex = require("cokeline.hlgroups").get_hl_attr

require("cokeline").setup({
	show_if_buffers_are_at_least = 2,
	default_hl = {
		fg = function(buffer)
			if buffer.is_focused then
				return get_hex("ColorColumn", "fg")
			else
				return get_hex("CokelineBackground", "fg")
			end
		end,
		bg = function(buffer)
			if buffer.is_focused then
				return get_hex("Normal", "bg")
			else
				return get_hex("CokelineBackground", "bg")
			end
		end,
	},
	components = {
		{
			text = function(buffer) return " " .. buffer.devicon.icon end,
			fg = function(buffer) return buffer.devicon.color end,
			on_click = function(_, _, _, _, buffer) safe_buffer_switch(buffer.number) end,
		},
		{
			text = function(buffer) return buffer.unique_prefix end,
			fg = get_hex("Comment", "fg"),
			italic = true,
			on_click = function(_, _, _, _, buffer) safe_buffer_switch(buffer.number) end,
		},
		{ text = function(buffer) return buffer.filename .. " " end, on_click = function(_, _, _, _, buffer) safe_buffer_switch(buffer.number) end },
		{ text = "", on_click = function(_, _, _, _, buffer) buffer:delete() end },
		{ text = " " },
	},
})

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

-- Setup Yazi
function EditFromYazi(paths_str)
	local files = {}
	for p in string.gmatch(paths_str, "%S+") do
		table.insert(files, p)
	end
	if #files == 0 then return end
	local path = vim.fn.expand("%:p")
	if path ~= files[1] then vim.cmd("e " .. files[1]) end
	for i = 2, #files do
		vim.cmd("tabedit " .. files[i])
	end
end

function VsplitFromYazi(file_path)
	local path = vim.fn.expand("%:p")
	if path == file_path then
		return
	else
		vim.cmd("vsplit " .. file_path)
	end
end

function SplitFromYazi(file_path)
	local path = vim.fn.expand("%:p")
	if path == file_path then
		return
	else
		vim.cmd("split " .. file_path)
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

local FloatingTerminalOpts = {
	border = "curved",
	title_pos = "center",
	width = function() return vim.o.columns - 10 end,
	height = function() return vim.o.lines - 5 end,
}

local Lazygit = Terminal:new({ -- lazygit terminal
	cmd = "lazygit",
	direction = "float",
	float_opts = FloatingTerminalOpts,
	name = "lazygit",
})

_G.ToggleLazygit = function() Lazygit:toggle() end

_G.ToggleYazi = function()
	Terminal:new({
		cmd = "yazi",
		direction = "float",
		float_opts = FloatingTerminalOpts,
		close_on_exit = true,
		on_close = function(term)
			if term.job_id and term.job_id > 0 then
				pcall(vim.fn.jobstop, term.job_id) -- kill hidden/leftover job
			end
		end,
	}):open()
end

_G.ToggleYaziBufDir = function()
	Terminal:new({
		cmd = "yazi",
		direction = "float",
		float_opts = FloatingTerminalOpts,
		dir = (vim.fn.expand("%:p:h") ~= "" and vim.fn.expand("%:p:h") or vim.loop.cwd()),
		close_on_exit = true,
		on_close = function(term)
			if term.job_id and term.job_id > 0 then
				pcall(vim.fn.jobstop, term.job_id) -- kill hidden/leftover job
			end
		end,
	}):open()
end

local Scooter = Terminal:new({ -- scooter terminal
	cmd = "scooter",
	direction = "float",
	float_opts = FloatingTerminalOpts,
	name = "scooter",
})

_G.ToggleScooter = function() Scooter:toggle() end

local FloatingTerminal = Terminal:new({ -- floating terminal
	direction = "float",
	float_opts = FloatingTerminalOpts,
	name = "floating_terminal",
	auto_scroll = false,
	env = { FISH_ENABLE_AUTOLOG = "1" },
})

_G.ToggleFloatingTerminal = function() FloatingTerminal:toggle() end

local HorizontalTerminal = Terminal:new({ -- horizontal terminal
	name = "terminal",
	direction = "horizontal",
	env = { FISH_ENABLE_AUTOLOG = "1" },
})

_G.ToggleHorizontalTerminal = function() HorizontalTerminal:toggle() end

local VerticalTerminal = Terminal:new({ -- vertical terminal
	name = "terminal",
	direction = "vertical",
	env = { FISH_ENABLE_AUTOLOG = "1" },
})

_G.ToggleVerticalTerminal = function() VerticalTerminal:toggle() end

function _G.SetTerminalKeymaps() -- Configure terminal keymaps
	local opts = { buffer = 0 }
	vim.keymap.set("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
	vim.keymap.set("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
	vim.keymap.set("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
	vim.keymap.set("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)
end

vim.cmd("autocmd! TermOpen term://*toggleterm#* lua SetTerminalKeymaps()")

-- Setup telescope
local select_one_or_multi = function(prompt_bufnr)
	local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
	local multi = picker:get_multi_selection()
	if not vim.tbl_isempty(multi) then
		require("telescope.actions").close(prompt_bufnr)
		for _, j in pairs(multi) do
			if j.path ~= nil then vim.cmd(string.format("%s %s", "edit", j.path)) end
		end
	else
		require("telescope.actions").select_default(prompt_bufnr)
	end
end

require("telescope").setup({
	defaults = {
		path_display = { "truncate" },
		mappings = { i = { ["<CR>"] = select_one_or_multi } },
	},
})

-- Setup auto session
require("auto-session").setup({
	suppressed_dirs = { "~/", "~/Documents", "~/Downloads", "/" },
})

-- Setup gradle
require("gradle").setup({
	keymaps = false,
	load_on_startup = true,
	disable_startup_notification = true,
	floating_terminal_opts = FloatingTerminalOpts,
})

-- Keymaps
local k = vim.keymap
k.set("", "<ScrollWheelDown>", "2<C-E>", { noremap = true, silent = true }) -- fix ghostty mouse lags in nvim
k.set("", "<ScrollWheelUp>", "2<C-Y>", { noremap = true, silent = true }) -- fix ghostty mouse lags in nvim
k.set("", "<Space>", "<Nop>", { desc = "Ignore space", silent = true, noremap = true }) -- hopefully fixing space as leader issue
k.set("n", "<A-Left>", "<Plug>(cokeline-focus-prev)", { desc = "Go to previous buffer", silent = true, noremap = true })
k.set("n", "<A-Right>", "<Plug>(cokeline-focus-next)", { desc = "Go to next buffer", silent = true, noremap = true })
k.set("n", "<A-S-Left>", "<Plug>(cokeline-switch-prev)", { desc = "Move buffer left", silent = true, noremap = true })
k.set("n", "<A-S-Right>", "<Plug>(cokeline-switch-next)", { desc = "Move buffer right", silent = true, noremap = true })
k.set("n", "<A-S-h>", "<Plug>(cokeline-switch-prev)", { desc = "Move buffer left", silent = true, noremap = true })
k.set("n", "<A-S-l>", "<Plug>(cokeline-switch-next)", { desc = "Move buffer right", silent = true, noremap = true })
k.set("n", "<A-h>", "<Plug>(cokeline-focus-prev)", { desc = "Go to previous buffer", silent = true, noremap = true })
k.set("n", "<A-l>", "<Plug>(cokeline-focus-next)", { desc = "Go to next buffer", silent = true, noremap = true })
k.set("n", "<A-w>", ":bdelete<CR>", { desc = "Close buffer", silent = true, noremap = true })
k.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window", silent = true, noremap = true })
k.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window", silent = true, noremap = true })
k.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window", silent = true, noremap = true })
k.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window", silent = true, noremap = true })
k.set("n", "<leader>/", require("telescope.builtin").live_grep, { desc = "Live grep", silent = true, noremap = true })
k.set("n", "<leader>D", vim.diagnostic.setloclist, { desc = "Open [D]iagnostic quickfix list", silent = true, noremap = true })
k.set("n", "<leader>E", ":lua ToggleYazi()<CR>", { desc = "Toggle Yazi in Working dir", silent = true, noremap = true })
k.set("n", "<leader>GG", ":lua require('gradle').telescope.pick_tasks()<CR>", { desc = "Gradle taks", silent = true, noremap = true })
k.set("n", "<leader>GR", ":lua require('gradle').tasks.refresh_tasks_async()<CR>", { desc = "Refresh Gradle", silent = true, noremap = true })
k.set("n", "<leader>GW", ":lua require('gradle').terminal.toggle()<CR>", { desc = "Gradle terminal", silent = true, noremap = true })
k.set("n", "<leader>TH", ":lua ToggleHorizontalTerminal()<CR>", { desc = "Toggle horizontal terminal", silent = true, noremap = true })
k.set("n", "<leader>TV", ":lua ToggleVerticalTerminal()<CR>", { desc = "Toggle vertical terminal", silent = true, noremap = true })
k.set("n", "<leader>b", require("telescope.builtin").buffers, { desc = "Find buffers", silent = true, noremap = true })
k.set("n", "<leader>e", ":lua ToggleYaziBufDir()<CR>", { desc = "Toggle Yazi in Buffer dir", silent = true, noremap = true })
k.set("n", "<leader>f", require("telescope.builtin").find_files, { desc = "Find files", silent = true, noremap = true })
k.set("n", "<leader>g", ":lua ToggleLazygit()<CR>", { desc = "Toggle Lazygit", silent = true, noremap = true })
k.set("n", "<leader>o", ":update<CR> :source<CR>", { desc = "Update and source config", silent = true, noremap = true })
k.set("n", "<leader>r", ":lua ToggleScooter()<CR>", { desc = "Toggle Scooter", silent = true, noremap = true })
k.set("n", "<leader>t", ":lua ToggleFloatingTerminal()<CR>", { desc = "Toggle floating terminal", silent = true, noremap = true })
k.set("n", "<leader>w", ":write<CR>", { desc = "Write buffer", silent = true, noremap = true })
k.set("n", "S", require("substitute").eol, { desc = "Substitute eol", silent = true, noremap = true })
k.set("n", "s", require("substitute").operator, { desc = "Substitute operator", silent = true, noremap = true })
k.set("n", "ss", require("substitute").line, { desc = "Substitute line", silent = true, noremap = true })
k.set("v", "<A-Left>", "<Esc><Plug>(cokeline-focus-prev)", { desc = "Go to previous buffer", silent = true, noremap = true })
k.set("v", "<A-Right>", "<Esc><Plug>(cokeline-focus-next)", { desc = "Go to next buffer", silent = true, noremap = true })
k.set("v", "<A-S-Left>", "<Esc><Plug>(cokeline-switch-prev)", { desc = "Move buffer left", silent = true, noremap = true })
k.set("v", "<A-S-Right>", "<Esc><Plug>(cokeline-switch-next)", { desc = "Move buffer right", silent = true, noremap = true })
k.set("v", "<A-S-h>", "<Esc><Plug>(cokeline-switch-prev)", { desc = "Move buffer left", silent = true, noremap = true })
k.set("v", "<A-S-l>", "<Esc><Plug>(cokeline-switch-next)", { desc = "Move buffer right", silent = true, noremap = true })
k.set("v", "<A-h>", "<Esc><Plug>(cokeline-focus-prev)", { desc = "Go to previous buffer", silent = true, noremap = true })
k.set("v", "<A-l>", "<Esc><Plug>(cokeline-focus-next)", { desc = "Go to next buffer", silent = true, noremap = true })
k.set("v", "<A-w>", "<Esc>:bdelete<CR>", { desc = "Close buffer", silent = true, noremap = true })
k.set("v", "<leader>/", "y<ESC>:Telescope live_grep default_text=<c-r>0<CR>", { desc = "Live grep", silent = true, noremap = true })
k.set("v", "<leader>f", "y<ESC>:Telescope find_files default_text=<c-r>0<CR>", { desc = "Live grep", silent = true, noremap = true })
k.set("v", "H", "<gv", { desc = "Move line(s) to the left", silent = true, noremap = true })
k.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line(s) down", silent = true, noremap = true })
k.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line(s) up", silent = true, noremap = true })
k.set("v", "L", ">gv", { desc = "Move line(s) to the right", silent = true, noremap = true })
k.set("x", "s", require("substitute").visual, { desc = "Substitute visual", silent = true, noremap = true })
