local shellcheck = require("lint.linters.shellcheck")
shellcheck.args = vim.list_extend({ "--enable", "all" }, shellcheck.args)

-- Don't ignore non-linting errors (e.g. configuration errors)
local ruff = require("lint.linters.ruff")
ruff.ignore_exitcode = false
table.insert(ruff.args, 1, "--exit-zero")

require("lint").linters_by_ft = {
  fish = { "fish" },
  go = { "golangcilint" },
  lua = { "selene" },
  python = { "pylint", "ruff" },
  sh = { "shellcheck" },
  vim = { "vint" },
  yaml = { "yamllint" },
}
