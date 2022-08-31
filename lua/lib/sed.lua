local M = {}

local esc = function(s) return vim.fn.escape(s, "/") end

-- Search and replace using `:substitute`
M.run = function(pattern, repl, flags, mods)
  flags = flags or { "g" }
  mods = mods or vim.empty_dict()
  local cmd = string.format("/%s/%s/", esc(pattern), esc(repl))
  for _, f in ipairs(flags) do
    cmd = cmd .. f
  end

  vim.cmd.substitute({
    args = { cmd },
    range = { 1, vim.fn.line("$") },
    mods = mods,
  })
end

return M
