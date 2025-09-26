-- Use noremap and silent for all keybinds
function Map(mode, lhs, rhs, opts)
  local options = { noremap = true, silent = true }
  if opts then options = vim.tbl_extend("force", options, opts) end
  vim.keymap.set(mode, lhs, rhs, options)
end

-- Ghostty mouse lag fix
-- Map("", "<ScrollWheelDown>", "2<C-E>", { desc = "Scroll down 2 lines" })
-- Map("", "<ScrollWheelUp>", "2<C-Y>", { desc = "Scroll up 2 lines" })

-- Cokeline navigation
Map("n", "<A-Left>", "<Plug>(cokeline-focus-prev)", { desc = "Focus previous buffer" })
Map("n", "<A-Right>", "<Plug>(cokeline-focus-next)", { desc = "Focus next buffer" })
Map("n", "<A-S-Left>", "<Plug>(cokeline-switch-prev)", { desc = "Move buffer left" })
Map("n", "<A-S-Right>", "<Plug>(cokeline-switch-next)", { desc = "Move buffer right" })
Map("n", "<A-S-h>", "<Plug>(cokeline-switch-prev)", { desc = "Move buffer left" })
Map("n", "<A-S-l>", "<Plug>(cokeline-switch-next)", { desc = "Move buffer right" })
Map("n", "<A-h>", "<Plug>(cokeline-focus-prev)", { desc = "Focus previous buffer" })
Map("n", "<A-l>", "<Plug>(cokeline-focus-next)", { desc = "Focus next buffer" })

-- Window management
Map("n", "<C-S-h>", "<C-w>H", { desc = "Move window left" })
Map("n", "<C-S-j>", "<C-w>J", { desc = "Move window down" })
Map("n", "<C-S-k>", "<C-w>K", { desc = "Move window up" })
Map("n", "<C-S-l>", "<C-w>L", { desc = "Move window right" })
Map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
Map("n", "<C-j>", "<C-w>j", { desc = "Move to window below" })
Map("n", "<C-k>", "<C-w>k", { desc = "Move to window above" })
Map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Buffer & file management
Map("n", "<A-w>", ":bdelete<CR>", { desc = "Close buffer" })
Map("n", "<leader>w", ":write<CR>", { desc = "Save file" })
Map("n", "<leader>ff", function() require("telescope.builtin").find_files() end, { desc = "Find files" })
Map("n", "<leader>fg", function() require("telescope.builtin").git_files() end, { desc = "Find git files" })
Map("n", "<leader>ft", function() require("telescope.builtin").live_grep() end, { desc = "Find text (grep)" })
Map("n", "<leader>fw", function() require("telescope.builtin").grep_string() end, { desc = "Find word under cursor" })
Map("n", "<leader>fb", function() require("telescope.builtin").buffers() end, { desc = "Find buffers" })
Map("n", "<leader>fh", function() require("telescope.builtin").help_tags() end, { desc = "Find help tags" })
Map("n", "<leader>fk", function() require("telescope.builtin").keymaps() end, { desc = "Find keymaps" })
Map("n", "<leader>fr", function() require("telescope.builtin").oldfiles() end, { desc = "Find recent files" })
Map("n", "<leader>fc", function() require("telescope.builtin").commands() end, { desc = "Find commands" })
Map("n", "<leader>fm", function() require("telescope.builtin").marks() end, { desc = "Find marks" })
Map("n", "<leader>fq", function() require("telescope.builtin").quickfix() end, { desc = "Find quickfix items" })
Map("n", "<leader>fl", function() require("telescope.builtin").loclist() end, { desc = "Find location list items" })
Map("v", "<leader>ft", function()
  vim.cmd('normal! "ay')
  require("telescope.builtin").grep_string({ default_text = vim.fn.getreg("a") })
end, { desc = "Find text with selection" })
Map("v", "<leader>ff", function()
  vim.cmd('normal! "ay')
  require("telescope.builtin").find_files({ default_text = vim.fn.getreg("a") })
end, { desc = "Find files with selection" })

-- Terminal toggles
Map("n", "<leader>th", ":lua ToggleHorizontalTerminal()<CR>", { desc = "Toggle horizontal terminal" })
Map("n", "<leader>tv", ":lua ToggleVerticalTerminal()<CR>", { desc = "Toggle vertical terminal" })
Map("n", "<leader>tt", ":lua ToggleFloatingTerminal()<CR>", { desc = "Toggle floating terminal" })
Map(
  "v",
  "<leader>tt",
  '"ay<ESC>:lua ToggleFloatingTerminal()<CR><C-\\><C-n>"ap i<CR>',
  { desc = "Toggle floating terminal with selection" }
)
Map(
  "v",
  "<leader>th",
  '"ay<ESC>:lua ToggleHorizontalTerminal()<CR><C-\\><C-n>"ap i<CR>',
  { desc = "Toggle horizontal terminal with selection" }
)
Map(
  "v",
  "<leader>tv",
  '"ay<ESC>:lua ToggleVerticalTerminal()<CR><C-\\><C-n>"ap i<CR>',
  { desc = "Toggle vertical terminal with selection" }
)

-- Miscellaneous
Map("n", "<leader>o", "o<Esc>", { desc = "New line below (normal mode)" })
Map("n", "<leader>O", "O<Esc>", { desc = "New line above (normal mode)" })
Map("n", "<leader>ep", ":lua ToggleYazi()<CR>", { desc = "Toggle Yazi project dir" })
Map("n", "<leader>ee", ":lua ToggleYaziBufDir()<CR>", { desc = "Toggle Yazi buf dir" })
Map("n", "<leader>gg", ":lua ToggleLazygit()<CR>", { desc = "Toggle Lazygit" })
Map("n", "<leader>rr", ":lua ToggleScooter()<CR>", { desc = "Toggle Scooter" })
Map(
  "v",
  "<leader>rr",
  '"ay<ESC><cmd>lua ToggleScooterSearchText(vim.fn.getreg("a"))<CR>',
  { desc = "Toggle Scooter with selection" }
)
Map("n", "<leader>Gg", ":GradlePickTasks<CR>", { desc = "Gradle pick tasks" })
Map("n", "<leader>Gr", ":GradleRefreshTasks<CR>", { desc = "Gradle refresh tasks" })
Map("n", "<leader>Gt", ":GradleToggleTerminal<CR>", { desc = "Gradle toggle terminal" })
Map("n", "<leader>?", function() require("which-key").show({ global = false }) end, { desc = "Local Keymaps" })

-- Code actions
Map("n", "<leader>cd", ":lua vim.lsp.buf.definition()<CR>", { desc = "Go to definition" })
Map("n", "<leader>ci", ":lua vim.lsp.buf.implementation()<CR>", { desc = "Go to implementation" })
Map("n", "<leader>cn", ":lua vim.lsp.buf.rename()<CR>", { desc = "Rename symbol" })
Map("n", "<leader>cr", ":lua vim.lsp.buf.references()<CR>", { desc = "List references" })
Map("n", "K", ":lua vim.lsp.buf.hover()<CR>", { desc = "Show hover documentation" })

-- Substitute plugin
Map("n", "S", function() require("substitute").eol() end, { desc = "Substitute to end of line" })
Map("n", "s", function() require("substitute").operator() end, { desc = "Substitute operator" })
Map("n", "ss", function() require("substitute").line() end, { desc = "Substitute line" })
Map("x", "s", function() require("substitute").visual() end, { desc = "Substitute selection" })

-- Terminal resizing
Map("t", "<C-Down>", "<cmd>resize -2<CR>", { desc = "Increase window height" })
Map("t", "<C-Up>", "<cmd>resize +2<CR>", { desc = "Decrease window height" })
Map("t", "<C-Left>", "<cmd>vertical resize +2<CR>", { desc = "Increase window width" })
Map("t", "<C-Right>", "<cmd>vertical resize -2<CR>", { desc = "Decrease window width" })

-- Visual mode bufferline
Map("v", "<A-Left>", "<Esc><Plug>(cokeline-focus-prev)", { desc = "Focus previous buffer" })
Map("v", "<A-Right>", "<Esc><Plug>(cokeline-focus-next)", { desc = "Focus next buffer" })
Map("v", "<A-S-Left>", "<Esc><Plug>(cokeline-switch-prev)", { desc = "Move buffer left" })
Map("v", "<A-S-Right>", "<Esc><Plug>(cokeline-switch-next)", { desc = "Move buffer right" })
Map("v", "<A-S-h>", "<Esc><Plug>(cokeline-switch-prev)", { desc = "Move buffer left" })
Map("v", "<A-S-l>", "<Esc><Plug>(cokeline-switch-next)", { desc = "Move buffer right" })
Map("v", "<A-h>", "<Esc><Plug>(cokeline-focus-prev)", { desc = "Focus previous buffer" })
Map("v", "<A-l>", "<Esc><Plug>(cokeline-focus-next)", { desc = "Focus next buffer" })
Map("v", "<A-w>", "<Esc>:bdelete<CR>", { desc = "Close buffer" })

-- Visual mode line movement
Map("v", "<S-Down>", ":m '>+1<CR>gv=gv", { desc = "Move line(s) down" })
Map("v", "<S-Left>", "<gv", { desc = "Move line(s) left" })
Map("v", "<S-Right>", ">gv", { desc = "Move line(s) right" })
Map("v", "<S-Up>", ":m '<-2<CR>gv=gv", { desc = "Move line(s) up" })
Map("v", "H", "<gv", { desc = "Move line(s) left" })
Map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move line(s) down" })
Map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move line(s) up" })
Map("v", "L", ">gv", { desc = "Move line(s) right" })

-- Yank tweaks
Map("n", "<Del>", '"_x', { desc = "Delete without yanking" })
Map("n", "C", '"_C', { desc = "Change without yanking" })
Map("n", "x", '"_x', { desc = "Delete without yanking" })
Map("v", "<Del>", '"_x', { desc = "Delete without yanking" })
Map("v", "x", '"_x', { desc = "Delete without yanking" })
Map({ "n", "x" }, "c", function() return '"_c' end, { expr = true, desc = "Change without yanking" })

local function is_ignored_terminal(bufname)
  local ignore_list = { "lazygit", "yazi", "jiratui", "scooter" }
  for _, term in ipairs(ignore_list) do
    if bufname:match(":" .. term) then return true end
  end
  return false
end

function _G.SetTerminalKeymaps() -- Configure terminal keymaps
  local bufname = vim.api.nvim_buf_get_name(0)
  local opts = { buffer = 0 }
  Map("t", "<C-h>", [[<Cmd>wincmd h<CR>]], opts)
  Map("t", "<C-j>", [[<Cmd>wincmd j<CR>]], opts)
  Map("t", "<C-k>", [[<Cmd>wincmd k<CR>]], opts)
  Map("t", "<C-l>", [[<Cmd>wincmd l<CR>]], opts)

  -- Do not use Esc to normal mode in certain terminals
  if is_ignored_terminal(bufname) then
    Map("t", "<Esc>", "<Esc>", opts)
  else
    Map("t", "<Esc>", [[<C-\><C-n>]], opts)
    Map("t", "<Esc><Esc>", [[<Cmd>hide<CR>]], opts)
  end
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd("autocmd! TermOpen term://* lua SetTerminalKeymaps()")
