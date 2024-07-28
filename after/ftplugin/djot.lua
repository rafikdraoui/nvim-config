local notes = require("notes")

vim.opt_local.foldmethod = "expr"
vim.opt_local.foldexpr = "v:lua.vim.treesitter.foldexpr()"

--  Disable highlighting for emphasis blocks
vim.cmd.highlight({ "link", "@markup.italic.djot", "Normal" })
vim.cmd.highlight({ "link", "@punctuation.delimiter.italic.djot", "Normal" })

vim.keymap.set("n", "<cr>", notes.jump, { buffer = true })

vim.b.minihipatterns_config = {
  highlighters = {
    note_link = { pattern = notes.link_pattern, group = "@markup.link.url" },
    note_tag = { pattern = notes.tag_pattern, group = "@attribute" },
  },
}
