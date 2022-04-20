local flake8 = require("lint.linters.flake8")
flake8.args = vim.list_extend(
  { "--append-config", vim.env.HOME .. "/.config/flake8" },
  flake8.args
)

local shellcheck = require("lint.linters.shellcheck")
shellcheck.args = vim.list_extend({ "--enable", "all" }, shellcheck.args)

require("lint").linters_by_ft = {
  go = { "golangcilint" },
  lua = { "selene" },
  python = { "flake8", "pylint" },
  sh = { "shellcheck" },
  vim = { "vint" },
  yaml = { "yamllint" },
}
