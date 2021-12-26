local formatting = require("null-ls").builtins.formatting
local diagnostics = require("null-ls").builtins.diagnostics

local sources = {
  -- diagnostics
  diagnostics.flake8.with({
    extra_args = { "--append-config", vim.env.HOME .. "/.config/flake8" },
  }),
  diagnostics.golangci_lint.with({
    extra_args = { "--fast=false" },
  }),
  diagnostics.pylint,
  diagnostics.selene,
  diagnostics.shellcheck,
  diagnostics.vint,
  diagnostics.yamllint,

  -- formatting
  formatting.black,
  formatting.fish_indent,
  formatting.fixjson,
  formatting.goimports,
  formatting.gofumpt,
  formatting.isort,
  formatting.prettier.with({
    disabled_filetypes = { "json" },
  }),
  formatting.rustfmt,
  formatting.shfmt.with({
    extra_args = { "-i", "2" },
  }),
  formatting.stylua,
  formatting.trim_newlines,
  formatting.trim_whitespace,
}

require("null-ls").setup({
  sources = sources,
})
