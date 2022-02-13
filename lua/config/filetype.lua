vim.filetype.add({
  extension = {
    md = function(path)
      if path:find(vim.env.NOTES_DIR) then
        return "vimwiki"
      else
        return "markdown"
      end
    end,
  },

  filename = {
    [".env"] = "text",
  },
})
