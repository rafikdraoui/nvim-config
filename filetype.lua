vim.filetype.add({
  extension = {
    d2 = "d2",
  },
  filename = {
    [".env"] = "text",
  },
  pattern = {
    ["${NOTES_DIR}/.*"] = "djot",
  },
})
