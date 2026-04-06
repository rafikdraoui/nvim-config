local notes = require("rafik.notes")

--  Disable highlighting for emphasis blocks
vim.cmd.highlight({ "link", "@markup.italic.djot", "Normal" })
vim.cmd.highlight({ "link", "@punctuation.delimiter.italic.djot", "Normal" })

vim.keymap.set("n", "<cr>", notes.jump, { buf = 0 })

vim.b.minihipatterns_config = {
  highlighters = {
    note_link = { pattern = notes.link_pattern, group = "@rafik.notes.link" },
    note_tag = { pattern = notes.tag_pattern, group = "@rafik.notes.tag" },
  },
}
