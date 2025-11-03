vim.pack.add({
  { src = "https://github.com/stevearc/conform.nvim" },
})

-- Setup conform auto-formatter
require("conform").setup({
  format_on_save = { timeout_ms = 5000, lsp_format = "fallback" },
  formatters_by_ft = {
    ansible = { "prettier", "codespell" },
    css = { "prettier", "codespell" },
    dockerfile = { "dockerfmt", "codespell" },
    fish = { "fish_indent", "codespell" },
    html = { "prettier", "codespell" },
    groovy = { "npm-groovy-lint", "codespell" },
    javascript = { "prettier", "codespell" },
    json = { "prettier", "codespell" },
    kotlin = { "ktlint", "codespell" },
    lua = { "stylua", "codespell" },
    markdown = { "prettier", "pymarkdownlnt" },
    php = { "php_cs_fixer" },
    python = { "black" },
    rust = { "rustfmt", "codespell" },
    sh = { "shfmt", "codespell" },
    terraform = { "terraform_fmt", "codespell" },
    tex = {},
    text = {},
    typescript = { "biome", "codespell" },
    yaml = { "prettier", "codespell" },
  },
})
