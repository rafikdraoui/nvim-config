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
