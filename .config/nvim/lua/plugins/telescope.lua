vim.pack.add({
  { src = "https://github.com/nvim-telescope/telescope.nvim" },
  { src = "https://github.com/nvim-lua/plenary.nvim" },
})

-- Setup telescope
require("telescope").setup({
  defaults = {
    layout_strategy = "flex", -- automatically switches between vertical/horizontal
    layout_config = {
      horizontal = { width = 0.99, height = 0.99, preview_width = 0.5 },
    },
    path_display = { "truncate" },
    borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
    mappings = {
      i = {
        ["<CR>"] = function(prompt_bufnr) -- Open multi with <CR>
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
        end,
      },
    },
  },
})
