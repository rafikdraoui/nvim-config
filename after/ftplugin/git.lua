vim.cmd.runtime("after/ftplugin/diff.vim")

vim.keymap.set({ "n", "x" }, "<cr>", function()
  if vim.startswith(vim.fn.bufname(), "minigit://") then
    require("mini.git").show_at_cursor()
  else
    vim.api.nvim_feedkeys(vim.keycode("<cr>"), "n", false)
  end
end, { buffer = true, desc = "Show git info at cursor" })
