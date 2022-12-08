vim.opt_local.spell = true
vim.cmd.runtime("after/ftplugin/diff.vim")

-- Trim whitespace in the commit message section, but do not touch the lines in
-- the diff. Trailing whitespace can be significant for syntax highlighting
-- diffs, so removing them can break it.
-- c.f. https://github.com/tpope/vim-git/issues/81
local trim_whitespace = function()
  local scissors_pattern = [[-\{24\} >8 -\{24\}]]
  local cutoff_line = vim.fn.search(scissors_pattern, "cnw")
  if cutoff_line == 0 then
    cutoff_line = vim.fn.line("$")
  end

  local flags = { "e" }
  local mods = { keeppatterns = true, silent = true }
  local range = { 1, cutoff_line }
  require("lib/sed").run([[\s\+$]], "", flags, mods, range)
end

-- Override `:TrimWhitespace` to only act on the commit message
vim.api.nvim_buf_create_user_command(
  0,
  "TrimWhitespace",
  trim_whitespace,
  { desc = "Trim trailing whitespace in Git commit message" }
)
