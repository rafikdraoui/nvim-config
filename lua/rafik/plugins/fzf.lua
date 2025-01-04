vim.cmd.packadd("fzf-lua")
local fzf = require("fzf-lua")

fzf.setup({
  fzf_opts = {
    ["--info"] = "default", -- use default finder info style instead of "inline"
  },
  defaults = {
    color_icons = false,
    file_icons = false,
    git_icons = false,
  },
  keymap = {
    builtin = {
      [1] = true, -- extend default mappings instead of overriding

      ["<a-p>"] = "toggle-preview",
      ["<a-j>"] = "preview-page-down",
      ["<a-k>"] = "preview-page-up",
    },
    fzf = {
      [1] = true, -- extend default mappings instead of overriding

      -- send all to quickfix
      -- (for providers using `file_edit_or_qf` in their default action)
      ["ctrl-q"] = "select-all+accept",
    },
  },
  winopts = {
    border = "single",
    preview = { hidden = "hidden" }, -- start with preview window hidden
  },
})

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
