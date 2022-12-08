vim.diagnostic.config({
  float = {
    header = false,
    source = true,
  },
  severity_sort = true,
})

local show_diagnostics = true
local toggle_diagnostics_display = function()
  show_diagnostics = not show_diagnostics
  vim.diagnostic.config({
    signs = show_diagnostics,
    underline = show_diagnostics,
    virtual_text = show_diagnostics,
  })
end

local map = function(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { desc = desc }) end
map("cod", toggle_diagnostics_display, "Toggle display of diagnostics")
map(
  "<leader>c",
  function() vim.diagnostic.setloclist({ open = true }) end,
  "Add buffer diagnostics to location list"
)
map(
  "<leader>e",
  function() vim.diagnostic.open_float() end,
  "Show diagnostics in a floating window"
)
map(
  "[e",
  function() vim.diagnostic.goto_prev({ wrap = false, float = false }) end,
  "Move to previous diagnostic"
)
map(
  "]e",
  function() vim.diagnostic.goto_next({ wrap = false, float = false }) end,
  "Move to next diagnostic"
)

-- Set signs symbol
local levels = { "Error", "Warn", "Info", "Hint" }
for _, l in pairs(levels) do
  local sign = "DiagnosticSign" .. l
  vim.fn.sign_define(sign, { text = "»", texthl = sign })
end
