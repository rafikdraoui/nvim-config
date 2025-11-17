vim.g["test#custom_strategies"] = {
  -- The 'toggleterm' strategy doesn't work when there are symbols that need to
  -- be escaped in the test command (like '$' in the fish shell).
  custom_toggleterm = function(cmd) require("toggleterm").exec(cmd) end,
}

vim.g["test#strategy"] = "custom_toggleterm"
vim.g["test#python#runner"] = "pytest"
vim.g["test#go#gotest#executable"] = "gotest"

vim.cmd.packadd("vim-test")

vim.keymap.set("n", "<leader>tn", vim.cmd.TestNearest, { desc = "Run nearest test" })
vim.keymap.set("n", "<leader>tf", vim.cmd.TestFile, { desc = "Run tests in file" })
vim.keymap.set("n", "<leader>ts", vim.cmd.TestSuite, { desc = "Run tests in suite" })
vim.keymap.set("n", "<leader>tl", vim.cmd.TestLast, { desc = "Re-run last test" })
vim.keymap.set("n", "<leader>tg", vim.cmd.TestVisit, { desc = "Go to last run test" })
