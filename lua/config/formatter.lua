local f = function(name, ...)
  local args = { ... }
  return function()
    return {
      exe = name,
      args = args,
      stdin = true,
    }
  end
end

local config = {
  fish = { f("fish_indent") },
  json = { f("fixjson") },
  lua = { f("stylua", "--search-parent-directories", "-") },
  python = {
    f("isort", "--stdout", "-"),
    f("black", "-"),
  },
  sh = { f("shfmt", "-i", "2") },
  toml = { f("taplo", "format", "-") },
}

local prettierd = function()
  -- Cannot use `f` factory function since `args` needs to be resolved at the
  -- time the formatter is running.
  return {
    exe = "prettierd",
    args = { vim.api.nvim_buf_get_name(0) },
    stdin = true,
  }
end
local prettierd_ft = {
  "css",
  "html",
  "javascript",
  "javascriptreact",
  "markdown",
  "yaml",
}
for _, ft in ipairs(prettierd_ft) do
  config[ft] = { prettierd }
end

require("formatter").setup({
  filetype = config,
})

vim.g.formatter_filetypes = vim.tbl_keys(config)
