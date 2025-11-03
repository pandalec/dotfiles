vim.pack.add({
  { src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
  { src = "https://github.com/mason-org/mason-lspconfig.nvim" },
  { src = "https://github.com/mason-org/mason.nvim" },
  { src = "https://github.com/neovim/nvim-lspconfig" },
  { src = "https://github.com/nvim-treesitter/nvim-treesitter" },
})

-- Treesitter setup
local treesitter_langs = {
  "bash",
  "css",
  "dockerfile",
  "fish",
  "groovy",
  "helm",
  "html",
  "hyprlang",
  "javascript",
  "jinja",
  "jinja_inline",
  "json",
  "kotlin",
  "lua",
  "markdown",
  "markdown_inline",
  "nginx",
  "php",
  "python",
  "rust",
  "terraform",
  "toml",
  "typescript",
  "yaml",
}

require("nvim-treesitter.configs").setup({
  ensure_installed = treesitter_langs,
  sync_install = false,
  -- auto_install = true,
  highlight = { enable = true, additional_vim_regex_highlighting = false },
})

-- vim.treesitter.highlighter.disable = function(lang, buf)
--   local max_filesize = 500 * 1024 -- 500 KB
--   local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
--   if ok and stats and stats.size > max_filesize then return true end
--   return false
-- end

-- Mason setup
require("mason").setup()

local lsp_servers = {
  "ansiblels",
  "bashls",
  "biome",
  "cssls",
  "dockerls",
  "fish_lsp",
  "groovyls",
  "helm_ls",
  "html",
  "hyprls",
  "jsonls",
  "kotlin_language_server",
  -- "kotlin_lsp",
  "lua_ls",
  "marksman",
  "phpactor",
  "pyright",
  "rust_analyzer",
  "systemd_ls",
  "taplo",
  "terraformls",
  "ts_ls",
  "yamlls",
}

local extra_tools = {
  "ansible-lint",
  "black",
  "codespell",
  -- "hadolint", -- dockerfile
  "kotlin-debug-adapter",
  "ktlint",
  "nginx-config-formatter",
  "nginx-language-server",
  "npm-groovy-lint",
  "php-cs-fixer",
  "prettier",
  "pymarkdownlnt",
  "shfmt",
  "stylua",
  "terraform",
  "tree-sitter-cli",
}

require("mason-lspconfig").setup({
  ensure_installed = lsp_servers,
  handlers = {
    -- default for all servers
    function(server) require("lspconfig")[server].setup({}) end,
    -- per-server override for lua_ls
    ["lua_ls"] = function()
      require("lspconfig").lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
          },
        },
      })
    end,
  },
})
require("mason-tool-installer").setup({ ensure_installed = vim.tbl_extend("force", lsp_servers, extra_tools) })

-- Filetype overrides
vim.filetype.add({
  pattern = {
    [".*%.gradle%.kts"] = "kotlin",
    [".*/hypr/.*%.conf"] = "hyprlang",
    [".*/playbooks/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.+/defaults/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.+/handlers/.*%.ya?ml"] = "yaml.ansible",
    [".*/roles/.+/tasks/.*%.ya?ml"] = "yaml.ansible",
  },
})

-- LSP specific settings
vim.diagnostic.config({
  -- virtual_text = true,
  virtual_text = false, -- only show in floating windows
  signs = true,
  float = { border = "rounded", source = "always" },
  -- update_in_insert = true,
  update_in_insert = false,
  severity_sort = true,
})
