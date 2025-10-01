vim.pack.add({
  { src = "https://github.com/Saghen/blink.cmp", version = "v1.7.0" },
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
