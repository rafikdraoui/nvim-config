local tmpdir = vim.pesc(vim.fn.resolve(vim.uv.os_tmpdir()))

vim.filetype.add({
  extension = {
    d2 = "d2",
  },
  pattern = {
    ["${NOTES_DIR}/.*"] = "djot",
    [tmpdir .. "/.*/screen%.txt"] = "ghostty_scrollback",
  },
})
