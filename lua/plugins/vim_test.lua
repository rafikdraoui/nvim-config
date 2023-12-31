vim.g["test#strategy"] = "toggleterm"
vim.g["test#python#runner"] = "pytest"
vim.g["test#go#gotest#executable"] = "gotest"

vim.cmd.packadd("vim-test")

vim.keymap.set("n", "t<c-n>", vim.cmd.TestNearest, { desc = "Run nearest test" })
vim.keymap.set("n", "t<c-f>", vim.cmd.TestFile, { desc = "Run tests in file" })
vim.keymap.set("n", "t<c-s>", vim.cmd.TestSuite, { desc = "Run tests in suite" })
vim.keymap.set("n", "t<c-l>", vim.cmd.TestLast, { desc = "Re-run last test" })
vim.keymap.set(
  "n",
  "t<c-g>",
  vim.cmd.TestVisit,
  { desc = "Navigate to test that was last run" }
)
