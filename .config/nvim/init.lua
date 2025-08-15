-- Set nvim options
vim.diagnostic.config({ update_in_insert = true })
vim.g.have_nerd_font = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.o.clipboard = "unnamedplus" -- use system clipboard
vim.o.confirm = true
vim.o.cursorline = true
vim.o.mouse = "a"           -- enable mouse in all modes
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

-- Set keymaps
vim.keymap.set("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })
vim.keymap.set("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
-- vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>") -- Escape highlight with <esc>
vim.keymap.set("n", "<leader>D", vim.diagnostic.setloclist, { desc = "Open [D]iagnostic quickfix list" })
-- vim.keymap.set("n", "<leader>fc", vim.lsp.buf.format)
vim.keymap.set("n", "<leader>o", ":update<CR> :source<CR>")
vim.keymap.set("n", "<leader>q", ":bdelete<CR>")
vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("v", "<leader>w", "<Esc>:write<CR>")
vim.keymap.set("v", "<A-h>", "<gv", { desc = "Move line(s) to the left" })
vim.keymap.set("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move line(s) down" })
vim.keymap.set("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move line(s) up" })
vim.keymap.set("v", "<A-l>", ">gv", { desc = "Move line(s) to the right" })
vim.keymap.set("n", " ", "<Nop>", { desc = "Ignore space", silent = true }) -- hopefully fixing space as leader issue

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
	{ src = "https://github.com/akinsho/bufferline.nvim.git" },                   -- custom bufferline
	{ src = "https://github.com/akinsho/toggleterm.nvim.git" },                   -- enables scooter and terminal function
	{ src = "https://github.com/catppuccin/nvim.git" },                           -- fav theme
	{ src = "https://github.com/gbprod/substitute.nvim.git" },                    -- substitute commands
	{ src = "https://github.com/kdheepak/lazygit.nvim.git" },                     -- enables lazygit
	{ src = "https://github.com/kylechui/nvim-surround.git" },                    -- surround add, delete and replace
	{ src = "https://github.com/mikavilpas/yazi.nvim" },                          -- enables yazi file manager
	{ src = "https://github.com/neovim/nvim-lspconfig" },                         -- default config for lsp's
	{ src = "https://github.com/numToStr/Comment.nvim.git" },                     -- enables comment function
	{ src = "https://github.com/nvim-lua/plenary.nvim" },                         -- dependency for yazi
	{ src = "https://github.com/nvim-telescope/telescope.nvim.git" },             -- fuzzy file, grep and buffer search
	{ src = "https://github.com/nvim-tree/nvim-web-devicons.git" },               -- dependency for bufferline
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },               -- treesitter
	{ src = "https://github.com/pandalec/gradle.nvim" },                          -- my gradle plugin :)
	{ src = "https://github.com/rmagatti/auto-session.git" },                     -- auto save and restore sessions
	{ src = "https://github.com/sschleemilch/slimline.nvim.git" },                -- slim statusline
	{ src = "https://github.com/stevearc/conform.nvim.git" },                     -- add format
	{ src = "https://github.com/windwp/nvim-autopairs" },                         -- autopairs for chars
	{ src = "https://github.com/Saghen/blink.cmp",                 version = "v1.6.0" }, -- try out another autocomplete
})

-- Enable lsp
vim.lsp.enable({
	"ansiblels",
	"bashls",
	"fish_lsp",
	-- "groovyls",
	"html",
	"jsonls",
	"kotlin_language_server",
	"lua_ls",
	"marksman",
	"rust_analyzer",
	"taplo",
	"yamlls",
})

-- Enable ansible lsp for yml files -- not needed anymore?
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
	},
})

require("blink.cmp").setup({
	signature = { enabled = true },
	keymap = {
		preset = "enter",
		["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
		["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
	},
	cmdline = {
		keymap = { preset = 'inherit' },
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
	},
})

-- Configure lua_ls that it wont show vim errors
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			diagnostics = {
				globals = { "vim" },
			},
		},
	},
})

-- Configure formatter
require("conform").setup({
	formatters_by_ft = {
		-- groovy = { "npm-groovy-lint" },
		kotlin = { "ktlint" },
		lua = { "stylua" },
		markdown = { "prettierd", "prettier", stop_after_first = true },
		-- yaml = { "ansible-lint", "prettierd", "prettier", stop_after_first = true },
		yaml = { "prettierd", "prettier", "ansible-lint", stop_after_first = true },
	},
	format_on_save = {
		-- These options will be passed to conform.format()
		-- timeout_ms = 500, -- Doesn't work for ansible-lint
		timeout_ms = 1500, -- Doesn't work for ansible-lint
		lsp_format = "fallback",
	},
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
require("nvim-surround").setup({})

-- Setup Comment
require("Comment").setup()
vim.keymap.set("n", "<leader>c", require("Comment.api").toggle.linewise.current,
	{ silent = true, desc = "Toggle comment line" })
vim.keymap.set("v", "<leader>c", "<Plug>(comment_toggle_linewise_visual)gv",
	{ silent = true, desc = "Toggle comment selection" })
vim.keymap.set("v", "<leader>C", "<Plug>(comment_toggle_blockwise_visual)gv",
	{ silent = true, desc = "Toggle block comment selection" })


-- Configure catpuccin
require("catppuccin").setup({
	flavour = "auto", -- latte, frappe, macchiato, mocha
	background = { -- :h background
		light = "latte",
		dark = "mocha",
	},
	-- transparent_background = true, -- disables setting the background color.
})
vim.cmd("colorscheme catppuccin")

-- Setup yazi
require("yazi").setup()
vim.keymap.set("n", "<leader>e", ":Yazi<CR>")

-- Setup lazygit
vim.keymap.set("n", "<leader>g", ":LazyGit<CR>")
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

-- Setup Terminal
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

local function create_terminal(term_opts, key_opts)
	term_opts.hidden = true
	term_opts.start_in_insert = true

	local term = Terminal:new(term_opts)

	local function toggle()
		term:toggle()
	end

	vim.keymap.set("n", key_opts.key, toggle, { noremap = true, silent = true, desc = key_opts.desc })

	return term
end

local scooter_term = create_terminal({
	cmd = "scooter",
	direction = "float",
	float_opts = { border = "curved", title_pos = 'center' },
	name = "scooter",
}, {
	desc = "Toggle scooter",
	key = "<leader>r",
})

create_terminal({
	direction = "float",
	float_opts = { border = "curved", title_pos = 'center' },
	name = "floating_terminal",
}, {
	desc = "Toggle floating terminal",
	key = "<leader>tt",
})

create_terminal({
	name = "terminal",
	direction = "horizontal",
}, {
	desc = "Toggle horizontal terminal",
	key = "<leader>th",
})

create_terminal({
	name = "terminal",
	direction = "vertical",
}, {
	desc = "Toggle vertical terminal",
	key = "<leader>tv",
})

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

-- Setup substitute
require("substitute").setup()
vim.keymap.set("n", "s", require("substitute").operator, { noremap = true })
vim.keymap.set("n", "ss", require("substitute").line, { noremap = true })
vim.keymap.set("n", "S", require("substitute").eol, { noremap = true })
vim.keymap.set("x", "s", require("substitute").visual, { noremap = true })

-- Setup telescope
vim.keymap.set("n", "<leader>f", require("telescope.builtin").find_files,
	{ desc = "Telescope find files", noremap = true })
vim.keymap.set("n", "<leader>l", require("telescope.builtin").live_grep,
	{ desc = "Telescope live grep", noremap = true })
vim.keymap.set("n", "<leader>b", require("telescope.builtin").buffers,
	{ desc = "Telescope buffers", noremap = true })
vim.keymap.set("n", "<leader>h", require("telescope.builtin").help_tags,
	{ desc = "Telescope help tags", noremap = true })

-- Enable multi select on telescope
local select_one_or_multi = function(prompt_bufnr)
	local picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
	local multi = picker:get_multi_selection()
	if not vim.tbl_isempty(multi) then
		require("telescope.actions").close(prompt_bufnr)
		for _, j in pairs(multi) do
			if j.path ~= nil then
				vim.cmd(string.format("%s %s", "edit", j.path))
			end
		end
	else
		require("telescope.actions").select_default(prompt_bufnr)
	end
end

require("telescope").setup({
	defaults = {
		mappings = {
			i = {
				["<CR>"] = select_one_or_multi,
			},
		},
		path_display = { "truncate" },
	},
})

-- Setup auto session
require("auto-session").setup({
	suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/" },
})

-- Setup gradle
require("gradle").setup({
	-- keymaps = false,
	load_on_startup = true,
	disable_start_notification = true,
})
