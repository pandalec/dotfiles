vim.pack.add({
  { src = "https://github.com/willothy/nvim-cokeline" },
  { src = "https://github.com/nvim-tree/nvim-web-devicons" },
})

-- Setup cokeline
local get_hex = require("cokeline.hlgroups").get_hl_attr

-- Keep TabLineFill transparent
vim.api.nvim_set_hl(0, "TabLineFill", { fg = "NONE", bg = "NONE" })

-- Hide ToggleTerm float if active, then switch buffer
local function safe_buffer_switch(button, buffer)
  local win = vim.api.nvim_get_current_win()
  local cfg = vim.api.nvim_win_get_config(win)

  -- If current window is floating
  if cfg.relative ~= "" then
    -- If it's a toggleterm terminal, hide it
    if vim.bo.buftype == "terminal" then
      local ok, toggleterm_terminal = pcall(require, "toggleterm.terminal")
      if ok then
        local term = toggleterm_terminal.get_or_create_term({ bufnr = vim.api.nvim_get_current_buf() })
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

  -- Finally, switch to the buffer, close if right click
  if button == "r" then
    buffer:delete()
  else
    vim.api.nvim_set_current_buf(buffer.number)
  end
end

require("cokeline").setup({
  show_if_buffers_are_at_least = 2,
  default_hl = {
    fg = function(buffer)
      if buffer.is_focused then
        return get_hex("Normal", "fg")
      else
        return get_hex("SignColumn", "fg")
      end
    end,
    bg = "NONE",
  },
  buffers = {
    delete_on_right_click = true,
  },
  components = {
    { text = " " },
    { -- icon
      text = function(buffer) return buffer.devicon.icon end,
      on_click = function(_, _, button, _, buffer) safe_buffer_switch(button, buffer) end,
    },
    { -- unique prefix
      text = function(buffer) return buffer.unique_prefix end,
      fg = function(buffer)
        if buffer.is_focused then
          return get_hex("Comment", "fg")
        else
          return get_hex("SignColumn", "fg")
        end
      end,
      italic = true,
      on_click = function(_, _, button, _, buffer) safe_buffer_switch(button, buffer) end,
    },
    { -- file name
      text = function(buffer) return buffer.filename end,
      on_click = function(_, _, button, _, buffer) safe_buffer_switch(button, buffer) end,
    },
    { text = " " },
    { -- Close or modified icon
      text = function(buffer) return buffer.is_modified and "" or "" end,
      on_click = function(_, _, _, _, buffer)
        if buffer.is_modified then
          safe_buffer_switch(buffer.number)
        else
          buffer:delete()
        end
      end,
    },
    { text = " " },
  },
})
