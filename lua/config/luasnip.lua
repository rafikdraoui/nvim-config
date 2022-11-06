local ls = require("luasnip")

require("luasnip.loaders.from_lua").lazy_load()

vim.keymap.set({ "i", "s" }, "<c-k>", function()
  if ls.expand_or_locally_jumpable() then
    ls.expand_or_jump()
  end
end, { desc = "luasnip: expand snippet or jump forwards" })

vim.keymap.set({ "i", "s" }, "<c-j>", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end, { desc = "luasnip: jump backwards" })

vim.api.nvim_create_user_command("Snippets", function()
  for _, snippets in pairs(ls.available()) do
    for _, snippet in ipairs(snippets) do
      local name = snippet.name
      local desc = snippet.description[1]
      if name == desc then
        desc = "[no description]"
      end
      print(string.format("%s: %s", name, desc))
    end
  end
end, { desc = "List snippets defined for current buffer" })
