-- Show available keybindings in a popup as you type
vim.pack.add({ "https://github.com/folke/which-key.nvim" })

local wk = require("which-key")

wk.setup({
  preset = "modern", -- classic, modern, helix
  show_help = false, -- <Esc> to close, <BS> to go back
  -- delay = 200,
  triggers = {
    { "<auto>", mode = "nixsotc" },
  },
  icons = {
    -- group = "+ ",
    rules = {
      { pattern = "code", icon = "", color = "blue" },
      { pattern = "buffer", icon = "", color = "cyan" },
      { pattern = "keymap", icon = "", color = "azure" },
      { pattern = "above", icon = "", color = "grey" },
      { pattern = "below", icon = "", color = "grey" },
      { pattern = "dir", icon = "", color = "orange" },
      { pattern = "explorer", icon = "", color = "orange" },
      { pattern = "nautilus", icon = "", color = "orange" },
      { pattern = "terminal", icon = "", color = "red" },
      { pattern = "gradle", icon = "", color = "green" },
      { pattern = "find", icon = "", color = "yellow" },
      { pattern = "git", icon = "", color = "red" },
      { pattern = "jira", icon = "", color = "blue" },
      { pattern = "surround", icon = "", color = "cyan" },
      { pattern = "scooter", icon = "󱖽", color = "yellow" },
      { pattern = "update", icon = "", color = "purple" },
    },
  },
})

wk.add({
  { "<leader>G", group = "Gradle" },
  { "<leader>c", group = "Code actions" },
  { "<leader>f", group = "Find ... with selection", mode = { "v" } },
  { "<leader>f", group = "Find ...", mode = { "n" } },
  { "<leader>e", group = "File Explorer" },
  { "<leader>g", group = "Lazygit" },
  { "<leader>j", group = "Jira" },
  { "<leader>n", group = "Nautilus" },
  { "<leader>r", group = "Replace ... with Scooter" },
  { "<leader>t", group = "Terminal with selection", mode = { "v" } },
  { "<leader>t", group = "Terminal", mode = { "n" } },
  { "<leader>u", group = "Update ..." },
})

-- Reserve unmapped <leader>a..z as <nop> and hide them in which-key
-- local modes = { "n", "v", "x", "o" }
local modes = { "n", "v" }
local hidden = {}
local alphabet = "abdhiklmopqsvwxyzABCDEFHIJKLMOPQRSTUVWXYZ"
local codes = { string.byte(alphabet, 1, #alphabet) }

local function has_map(lhs, mode)
  local m = vim.fn.maparg(lhs, mode, false, true)
  return type(m) == "table" and m.rhs ~= nil and m.rhs ~= ""
end

for i = 1, #codes do
  local c = string.char(codes[i])
  local lhs = "<leader>" .. c
  for _, m in ipairs(modes) do
    if not has_map(lhs, m) then
      -- vim.notify("Reserving: " .. lhs .. " in mode=" .. m)
      vim.keymap.set(m, lhs, "<nop>", { noremap = true, silent = true, desc = "deactivated" })
      table.insert(hidden, { lhs, hidden = true, mode = m })
      -- else
      --   vim.notify("Already mapped: " .. lhs .. " in mode=" .. m)
    end
  end
end

wk.add(hidden)
