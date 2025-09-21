vim.pack.add({
  { src = "https://github.com/pandalec/jiratui.nvim" },
})

-- Setup gradle
require("jiratui").setup({
  filters = {
    default_jql_id = 1,
    max_results = -1,
  },
  terminal = {
    float_opts = FloatingTerminalOpts,
  },
  git = { branch_template = "ticket/{key}-{slug}", commit_template = "{key}: {summary}" },
  debug = false,
  cache = { enabled = true, ttl_minutes = 10, background_refresh = true },
  keymaps = true,
  load_on_startup = true,
  telescope = {
    picker_fields = { "key", "summary", "status", "type", "fixVersions", "customfield_10094", "assignee" },
    preview_fields = { "fixVersions", "customfield_10094", "customfield_10097", "description" },
    sort_by = "updated",
    group_by = "none", -- "none" | "status" | "assignee" | "customfield_10094"
    group_custom_fields = {
      { id = "customfield_10094", name = "Components" },
      { id = "customfield_10097", name = "Project" },
    },
    show_group_headers = true,
  },
})
