local M = {}

local function repo_dir_from_current_file()
  local file_dir = vim.fn.expand("%:p:h")
  return vim.fn.fnamemodify(file_dir .. "/../.", ":p")
end

local function git(cmd, cwd)
  local full = { "git", "-C", cwd }
  vim.list_extend(full, cmd)
  local out = vim.fn.systemlist(full)
  local code = vim.v.shell_error
  return code, out
end

local function bin_exists(bin) return vim.fn.executable(bin) == 1 end

local function pick_base(cwd)
  -- prefer main, else master, else origin/HEAD target, else "main"
  if git({ "show-ref", "--verify", "--quiet", "refs/heads/main" }, cwd) == 0 then return "main" end
  if git({ "show-ref", "--verify", "--quiet", "refs/heads/master" }, cwd) == 0 then return "master" end
  local _, head = git({ "symbolic-ref", "refs/remotes/origin/HEAD" }, cwd)
  if head and head[1] then
    local m = head[1]:match("refs/remotes/origin/(.+)$")
    if m and #m > 0 then return m end
  end
  return "main"
end

local function extract_url(lines)
  if not lines then return nil end
  local text = table.concat(lines, "\n")
  local url = text:match("(https?://[%w%p]+)")
  return url
end

local function open_url(url)
  if not url then return end
  if vim.ui and vim.ui.open then
    pcall(vim.ui.open, url)
  else
    vim.fn.jobstart({ "xdg-open", url }, { detach = true })
  end
end

function M.open_pr(opts)
  opts = opts or {}
  if not bin_exists("tea") then
    vim.notify("tea CLI not found in PATH", vim.log.levels.ERROR)
    return
  end

  local cwd = repo_dir_from_current_file()

  -- current branch
  local code_b, br = git({ "rev-parse", "--abbrev-ref", "HEAD" }, cwd)
  if code_b ~= 0 or not br[1] or br[1] == "HEAD" then
    vim.notify("Cannot detect current branch", vim.log.levels.ERROR)
    return
  end
  local head_branch = br[1]

  -- base branch
  local base_branch = opts.base or pick_base(cwd)
  if base_branch == head_branch then
    vim.notify(("Head equals base (%s). Aborting."):format(head_branch), vim.log.levels.ERROR)
    return
  end

  -- title from last commit subject or branch name
  local _, subj = git({ "log", "-1", "--pretty=%s" }, cwd)
  local title = opts.title or (subj and subj[1]) or ("PR: " .. head_branch)

  -- description from last commit body (optional)
  local _, body = git({ "log", "-1", "--pretty=%b" }, cwd)
  local body_text = table.concat(body or {}, "\n")

  -- common args
  local common = {
    "--repo",
    cwd,
    "--title",
    title,
    "--base",
    base_branch,
    "--head",
    head_branch,
  }

  -- include body if present
  if body_text and #vim.trim(body_text) > 0 then
    table.insert(common, "--body")
    table.insert(common, body_text)
  end

  -- try `tea pr create`
  local out = vim.fn.systemlist(vim.list_extend({ "tea", "pr", "create" }, vim.deepcopy(common)))
  if vim.v.shell_error ~= 0 then
    -- fallback to `tea pull create`
    out = vim.fn.systemlist(vim.list_extend({ "tea", "pull", "create" }, common))
  end

  if vim.v.shell_error ~= 0 then
    vim.notify(table.concat(out, "\n"), vim.log.levels.ERROR)
    return
  end

  local url = extract_url(out)
  if url then open_url(url) end
  vim.notify(("PR created from %s -> %s"):format(head_branch, base_branch), vim.log.levels.INFO)
end

return M
