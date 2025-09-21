vim.pack.add({
  { src = "https://github.com/akinsho/toggleterm.nvim" },
})

-- Setup ToggleTerm
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
  highlights = {
    Normal = { link = "Normal" },
    NormalFloat = { link = "NormalFloat" },
    FloatBorder = { link = "FloatBorder" },
    FloatTitle = { link = "FloatTitle" },
  },
})

-- Setup external file handling, line is optional
_G.OpenFromExternal = function(command, file_path, line)
  local current_path = vim.fn.expand("%:p")
  local target_path = vim.fn.fnamemodify(file_path, ":p")
  if current_path ~= target_path then vim.cmd(command .. " " .. vim.fn.fnameescape(file_path)) end
  if line ~= nil then vim.api.nvim_win_set_cursor(0, { line, 0 }) end
end

-- Setup external file handling for Yazi
_G.EditMultiFromYazi = function(paths_str)
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

local Terminal = require("toggleterm.terminal").Terminal

_G.FloatingTerminalOpts = {
  border = "curved",
  title_pos = "center",
  width = math.floor(vim.o.columns * 0.98),
  height = math.floor(vim.o.lines * 0.9),
}

local Lazygit = Terminal:new({ -- lazygit terminal
  cmd = "lazygit",
  direction = "float",
  float_opts = FloatingTerminalOpts,
  name = "lazygit",
  on_close = function() vim.cmd("checktime") end,
})

_G.ToggleLazygit = function()
  -- Check if inside a Git repository
  local git_status = vim.fn.systemlist("git rev-parse --is-inside-work-tree")[1]
  if git_status == "true" then
    Lazygit:toggle()
  else
    vim.notify("This is not a Git repository!", vim.log.levels.WARN)
  end
end

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

local ScooterParamsExclude = { "ansible/**", "build/**", ".git/**" }
local ScooterParams = '--hidden --fixed-strings --files-to-exclude="' .. table.concat(ScooterParamsExclude, ",") .. '"'
local Scooter = Terminal:new({ -- scooter terminal
  cmd = "scooter " .. ScooterParams,
  direction = "float",
  float_opts = FloatingTerminalOpts,
  name = "scooter",
  on_close = function() vim.cmd("checktime") end,
})

_G.ToggleScooter = function() Scooter:toggle() end
_G.ToggleScooterSearchText = function(search_text)
  if not search_text or search_text == "" then
    Scooter:toggle()
    return
  end
  Scooter.cmd = "scooter " .. ScooterParams .. " --search-text '" .. search_text:gsub("'", "'\\''") .. "'"
  Scooter:toggle()
  Scooter.cmd = "scooter " .. ScooterParams
end

local FloatingTerminal = Terminal:new({ -- floating terminal
  direction = "float",
  float_opts = FloatingTerminalOpts,
  name = "floating_terminal",
  auto_scroll = false,
  env = { FISH_ENABLE_AUTOLOG = "1" },
  on_close = function() vim.cmd("checktime") end,
})

_G.ToggleFloatingTerminal = function() FloatingTerminal:toggle() end

local HorizontalTerminal = Terminal:new({ -- horizontal terminal
  name = "terminal",
  direction = "horizontal",
  env = { FISH_ENABLE_AUTOLOG = "1" },
  on_close = function() vim.cmd("checktime") end,
})

_G.ToggleHorizontalTerminal = function() HorizontalTerminal:toggle() end

local VerticalTerminal = Terminal:new({ -- vertical terminal
  name = "terminal",
  direction = "vertical",
  env = { FISH_ENABLE_AUTOLOG = "1" },
  on_close = function() vim.cmd("checktime") end,
})

_G.ToggleVerticalTerminal = function() VerticalTerminal:toggle() end
