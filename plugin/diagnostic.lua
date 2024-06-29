vim.diagnostic.config({
  float = {
    header = false,
    source = true,
  },
  severity_sort = true,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "»",
      [vim.diagnostic.severity.WARN] = "»",
      [vim.diagnostic.severity.INFO] = "»",
      [vim.diagnostic.severity.HINT] = "»",
    },
  },
})

local map = function(lhs, rhs, desc) vim.keymap.set("n", lhs, rhs, { desc = desc }) end
map(
  "cod",
  function() vim.diagnostic.enable(not vim.diagnostic.is_enabled()) end,
  "Toggle display of diagnostics"
)
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
