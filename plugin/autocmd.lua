local autocmd = vim.api.nvim_create_autocmd

local g = vim.api.nvim_create_augroup("main", { clear = true })

autocmd({ "TextYankPost" }, {
  desc = "Highlight yanked text briefly",
  group = g,
  callback = function() vim.hl.on_yank() end,
})

autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  desc = "Trigger `autoread` when file changes on disk",
  group = g,
  callback = function()
    if vim.fn.getcmdwintype() == "" then
      vim.cmd.checktime()
    end
  end,
})

autocmd({ "FileChangedShellPost" }, {
  desc = "Print message when file was changed outside of Vim",
  group = g,
  callback = function()
    vim.notify("File changed on disk. Buffer reloaded", vim.log.levels.WARN)
  end,
})

autocmd({ "TermOpen" }, {
  desc = "Make terminal start in insert mode",
  group = g,
  command = "startinsert",
})

autocmd({ "TermEnter" }, {
  desc = "Set statuline for toggleterm terminals",
  pattern = "term://*toggleterm#*",
  group = g,
  callback = function() vim.opt_local.statusline = "%1*terminal " .. vim.b.toggle_number end,
})

autocmd({ "FocusGained", "BufEnter", "CursorHold", "CursorHoldI" }, {
  desc = "Set 'showbreak' symbol so that it aligns to the right of the line number column ",
  group = g,
  callback = function()
    -- the width of the column varies depending on the number of lines in the buffer.
    local num_lines = vim.fn.line("$")
    local indent = string.rep(" ", math.floor(math.log10(num_lines)))
    vim.opt.showbreak = indent .. "⋯"
  end,
})

autocmd({ "BufWritePre" }, {
  desc = "Trim whitespace on save",
  group = g,
  command = "TrimWhitespace",
})

autocmd({ "ColorScheme" }, {
  desc = "Set status line custom highlights when colorscheme is changed",
  group = g,
  callback = function() require("rafik.statusline").set_status_highlights() end,
})
