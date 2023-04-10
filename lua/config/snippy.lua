local snippy = require("snippy")
local mappings = require("snippy.mapping")

vim.keymap.set("i", "<tab>", mappings.expand_or_advance("<tab>"))
vim.keymap.set("s", "<tab>", mappings.next("<tab>"))
vim.keymap.set({ "i", "s" }, "<s-tab>", mappings.previous("<s-tab>"))

vim.api.nvim_create_user_command("Snippets", function()
  for _, citem in ipairs(snippy.get_completion_items()) do
    local snippet = citem.user_data.snippy.snippet
    local name = snippet.prefix
    local desc = snippet.description or "[no description]"
    print(string.format("%s: %s", name, desc))
  end
end, { desc = "List snippets defined for current buffer" })
