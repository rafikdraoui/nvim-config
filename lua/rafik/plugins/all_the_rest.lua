-- debugprint.nvim
vim.cmd.packadd("debugprint.nvim")
require("debugprint").setup()
vim.api.nvim_set_hl(0, "DebugPrintLine", { link = "Error" })
vim.keymap.set(
  "n",
  "g?d",
  vim.cmd.DeleteDebugPrints,
  { desc = "Delete Debugprint lines" }
)
vim.keymap.set(
  "n",
  "g?q",
  vim.cmd.DebugPrintQFList,
  { desc = "Display Debugprint lines in quickfix list" }
)

-- git-messenger
-- see also: after/ftplugin/gitmessengerpopup.vim
vim.g.git_messenger_no_default_mappings = true
vim.g.git_messenger_always_into_popup = true
vim.cmd.packadd("git-messenger.vim")
vim.keymap.set("n", "gb", "<plug>(git-messenger)")

-- gutentags
vim.g.gutentags_file_list_command = { markers = { [".git"] = "git ls-files" } }
vim.g.gutentags_cache_dir = vim.fn.expand("~/.cache/tags")
vim.cmd.packadd("vim-gutentags")

-- lsp-format
vim.cmd.packadd("lsp-format.nvim")
local lsp_format = require("lsp-format")
lsp_format.setup()
vim.keymap.set("n", "cof", function()
  vim.cmd.FormatToggle()
  local enabled = not lsp_format.disabled
  print(string.format("formatting: %s", enabled))
end, { desc = "Toggle auto-formatting" })

-- markdown ftplugin (from default $VIMRUNTIME)
vim.g.markdown_folding = 1

-- miniyank
vim.cmd.packadd("nvim-miniyank")
vim.keymap.set({ "n", "x" }, "p", "<plug>(miniyank-autoput)")
vim.keymap.set({ "n", "x" }, "P", "<plug>(miniyank-autoPut)")
vim.keymap.set("", "<c-p>", "<plug>(miniyank-cycle)")
vim.keymap.set("", "<c-n>", "<plug>(miniyank-cycleback)")

-- notes
-- no 'packadd' here, because this plugin is part of the dotfiles
vim.keymap.set(
  "n",
  "<leader>n",
  require("rafik.notes").edit,
  { desc = "Edit/create/search notes" }
)

-- switch-repo
-- no 'packadd' here, because this plugin is part of the dotfiles
vim.keymap.set(
  "n",
  "<leader>pp",
  function()
    require("rafik.switch_repo").switch({
      search_paths = vim.g.switch_repo_default_search_paths,
    })
  end,
  { desc = "Switch repo" }
)
vim.keymap.set("n", "<leader>pv", function()
  require("rafik.switch_repo").switch({
    prompt = "Vim plugins",
    search_paths = vim.tbl_map(function(path)
      local home_rel_path = vim.fs.relpath(vim.env.HOME, path)
      if home_rel_path then
        return home_rel_path
      else
        return path
      end
    end, vim.api.nvim_get_runtime_file("pack", true)),
  })
end, { desc = "Switch repo (vim plugins)" })

-- toggleterm
vim.cmd.packadd("toggleterm.nvim")
require("toggleterm").setup({ open_mapping = [[<c-\>]] })

-- undotree
vim.cmd.packadd("undotree")
require("undotree").setup({ float_diff = false })
vim.keymap.set(
  "n",
  "cou",
  function() require("undotree").toggle() end,
  { desc = "Toggle undotree" }
)

-- unicode-picker
-- no 'packadd' here, because this plugin is part of the dotfiles
vim.keymap.set(
  { "i", "n" },
  "<a-u>",
  function() require("rafik.unicode_picker").pick() end,
  { desc = "Insert Unicode character" }
)

-- vim-projectionist
vim.g.projectionist_heuristics = {
  ["go.mod"] = {
    ["*.go"] = { alternate = "{}_test.go" },
    ["*_test.go"] = { type = "test", alternate = "{}.go" },
  },
}
vim.cmd.packadd("vim-projectionist")

-- vim-qf
-- See also: after/ftplugin/qf.vim
vim.g.qf_auto_resize = 0
vim.cmd.packadd("vim-qf")
vim.keymap.set("n", "<leader>q", "<plug>(qf_qf_toggle_stay)")
vim.keymap.set("n", "<leader>z", "<plug>(qf_loc_toggle_stay)")

-- vim-startuptime
vim.cmd.packadd("vim-startuptime")
vim.g.startuptime_event_width = 0

-- vim-subversive
vim.g.subversiveCurrentTextRegister = "s"
vim.cmd.packadd("vim-subversive")
vim.keymap.set({ "n", "x" }, "cs", "<plug>(SubversiveSubstituteRange)")
vim.keymap.set("n", "css", "<plug>(SubversiveSubstituteWordRange)")
