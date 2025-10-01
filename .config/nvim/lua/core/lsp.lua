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
  "yaml",
}

require("nvim-treesitter.configs").setup({
  ensure_installed = treesitter_langs,
  sync_install = true,
  auto_install = true,
  highlight = { enable = true, additional_vim_regex_highlighting = false },
})

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
  virtual_text = true,
  float = { border = "rounded", source = "always" },
  update_in_insert = true,
  severity_sort = true,
})
