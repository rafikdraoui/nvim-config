vim.filetype.add({
  filename = {
    [".env"] = "text",
  },
  pattern = {
    ["${NOTES_DIR}/.*"] = "djot",
  },
})
