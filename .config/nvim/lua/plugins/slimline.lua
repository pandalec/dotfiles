vim.pack.add({
  { src = "https://github.com/sschleemilch/slimline.nvim" },
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
