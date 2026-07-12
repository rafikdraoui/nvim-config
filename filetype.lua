vim.filetype.add({
  extension = {
    d2 = "d2",
  },
  pattern = {
    ["${NOTES_DIR}/.*"] = "djot",
  },
})
