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
  virtual_text = true,
})

vim.keymap.set("n", "<localleader>d", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
  print(string.format("diagnostics: %s", vim.diagnostic.is_enabled()))
end, { desc = "Toggle display of diagnostics" })

vim.keymap.set(
  "n",
  "<leader>e",
  function() vim.diagnostic.open_float() end,
  { desc = "Show diagnostics in a floating window" }
)
