local shellcheck = require("lint.linters.shellcheck")
shellcheck.args = vim.list_extend({ "--enable", "all" }, shellcheck.args)

local ruff = require("lint.linters.ruff")
local ruff_select = {
  "B", -- flake8-bugbear
  "C4", -- flake8-comprehensions
  "PLC", -- pylint
  "PLE", -- "
  "PLR", -- "
  "PLW", -- "
  "RET", -- flake8-return
  "RUF", -- ruff "meta" checks
  "UP", -- pyupgrade
  "W", -- warnings
}
local ruff_ignore = {
  "E501", -- line too long
  "RET504", -- unnecessary assignment before `return` statement
}
ruff.ignore_exitcode = false
ruff.args = {
  "--quiet",
  "--exit-zero",
  "--extend-select",
  table.concat(ruff_select, ","),
  "--extend-ignore",
  table.concat(ruff_ignore, ","),
  "-",
}

require("lint").linters_by_ft = {
  fish = { "fish" },
  go = { "golangcilint" },
  lua = { "selene" },
  python = { "pylint", "ruff" },
  sh = { "shellcheck" },
  vim = { "vint" },
  yaml = { "yamllint" },
}
