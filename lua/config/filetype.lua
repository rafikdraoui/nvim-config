require("filetype").setup({
  overrides = {
    literal = {
      [".envrc"] = "sh",
      [".python-version"] = "text",
    },
    extensions = {
      ["patch"] = "diff",
    },
    complex = {
      [".*/systemd/.*.service$"] = "systemd",
      [".*/systemd/.*.target$"] = "systemd",
      [".*/systemd/.*.timer$"] = "systemd",
    },
    function_extensions = {
      ["md"] = function()
        local fullpath = vim.fn.expand("%:p")
        if fullpath:find(vim.env.NOTES_DIR) then
          vim.bo.filetype = "vimwiki"
        else
          vim.bo.filetype = "markdown"
        end
      end,
    },
  },
})

-- load filetype detection commands from 3rd-party plugins
vim.cmd([[runtime! ftdetect/*.vim]])
vim.cmd([[runtime! ftdetect/*.lua]])
