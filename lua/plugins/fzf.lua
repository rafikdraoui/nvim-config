vim.cmd.packadd("fzf-lua")
local fzf = require("fzf-lua")

-- Extend default key mappings
local keymap = vim.deepcopy(fzf.defaults.keymap)
keymap.builtin["<a-p>"] = "toggle-preview"
keymap.builtin["<a-j>"] = "preview-page-down"
keymap.builtin["<a-k>"] = "preview-page-up"
-- send all to quickfix
-- (for providers using `file_edit_or_qf` in their default action)
keymap.fzf["ctrl-q"] = "select-all+accept"

fzf.setup({
  fzf_opts = {
    ["--info"] = "default", -- use default finder info style instead of "inline"
  },
  global_git_icons = false,
  keymap = keymap,
  winopts = {
    border = "single",
    preview = { hidden = "hidden" }, -- start with preview window hidden
  },
})

-- Use fzf-lua as provider for `vim.ui.select`
fzf.register_ui_select()

vim.keymap.set("n", "<c-f>", fzf.git_files, { desc = "fzf: git files" })
vim.keymap.set("n", "<c-h>", fzf.help_tags, { desc = "fzf: help tags" })
vim.keymap.set("n", "<leader>r", fzf.resume, { desc = "fzf: resume" })
vim.keymap.set("n", "gr<space>", fzf.lsp_finder, { desc = "fzf: LSP info for symbol" })
vim.keymap.set(
  "n",
  "<leader>pd",
  function() fzf.git_files({ cwd = "~/dotfiles", prompt = "Dotfiles> " }) end,
  { desc = "fzf: dotfiles" }
)
vim.keymap.set(
  "n",
  "<leader>n",
  function() fzf.files({ cwd = vim.env.NOTES_DIR }) end,
  { desc = "fzf: notes" }
)
