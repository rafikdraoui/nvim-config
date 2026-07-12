vim.cmd.packadd("nvim-snippy")

vim.keymap.set(
  "i",
  "<tab>",
  function() require("snippy.mapping").expand_or_advance("<tab>")() end,
  { desc = "Expand snippet, or go to next placeholder" }
)
vim.keymap.set(
  "s",
  "<tab>",
  function() require("snippy.mapping").next("<tab>")() end,
  { desc = "Go to next snippet placeholder" }
)
vim.keymap.set(
  { "i", "s" },
  "<s-tab>",
  function() require("snippy.mapping").previous("<s-tab>")() end,
  { desc = "Go to previous snippet placeholder" }
)

vim.api.nvim_create_user_command("Snippets", function()
  for _, citem in ipairs(require("snippy").get_completion_items()) do
    local snippet = citem.user_data.snippy.snippet
    local name = snippet.prefix
    local desc = snippet.description or "[no description]"
    vim.notify(string.format("%s: %s", name, desc))
  end
end, { desc = "List snippets defined for current buffer" })
