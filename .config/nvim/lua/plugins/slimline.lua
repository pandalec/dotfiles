vim.pack.add({
  { src = "https://github.com/sschleemilch/slimline.nvim" },
})

-- -- in your slimline config
-- local function recording_segment()
--   local reg = vim.fn.reg_recording()
--   if reg ~= "" then return "Recording @" .. reg end
--   return ""
-- end

-- Setup slimline status line
require("slimline").setup({
  style = "fg",
  bold = true,
  hl = { secondary = "Comment" },
  -- components = {
  --   left = {
  --     "mode",
  --     "path",
  --     "git",
  --   },
  --   center = {
  --     recording_segment,
  --   },
  --   right = {
  --     "diagnostics",
  --     "filetype_lsp",
  --     "progress",
  --   },
  -- },
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
