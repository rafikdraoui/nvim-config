local command = vim.api.nvim_create_user_command

command("Bonly", function()
  local hidden_buffers = vim.tbl_filter(
    function(buf) return buf.hidden == 1 end,
    vim.fn.getbufinfo({ buflisted = true })
  )
  local buf_numbers = vim.tbl_map(function(buf) return buf.bufnr end, hidden_buffers)

  if not vim.tbl_isempty(buf_numbers) then
    -- Cannot use `vim.cmd.bdelete` since this would interpret the arguments as
    -- buffer names instead of buffer numbers
    vim.cmd("bdelete " .. table.concat(buf_numbers, " "))
  end
end, { desc = "Delete hidden buffers" })

command("Redir", function(opts)
  local output = vim.fn.execute(opts.args)
  local lines = vim.split(output, "\n", { trimempty = true })
  require("rafik.scratch").create(lines)
end, {
  desc = "Redirect output of Ex command into a scratch buffer",
  nargs = "+",
  complete = "command",
})

command("ToSystemClipboard", function()
  local last_yank = vim.fn.getreginfo("@")
  vim.fn.setreg("+", last_yank)
end, { desc = "Copy last yank to system clipboard" })

command(
  "CdRoot",
  function() require("rafik.git").cd_root() end,
  { desc = "Set cwd to root of git repository (if applicable)" }
)

command(
  "CdBuffer",
  function() vim.cmd.cd("%:p:h") end,
  { desc = "Set cwd to directory containing the file loaded in buffer" }
)

command(
  "GoDoc",
  function(opts) require("rafik.browse").golang_docs(opts.fargs[1]) end,
  { desc = "Browse Go documentation", nargs = "*" }
)

command(
  "PyDoc",
  function(opts) require("rafik.browse").python_docs(opts.fargs[1]) end,
  { desc = "Browse Python documentation", nargs = "*" }
)

command(
  "RustDoc",
  function(opts) require("rafik.browse").rust_docs(opts.args) end,
  { desc = "Browse Rust documentation", nargs = "*" }
)

command("TrimWhitespace", function()
  local sed = require("rafik.sed").run

  -- Save cursor position
  local view = vim.fn.winsaveview()

  local flags = { "e" }
  local mods = { keeppatterns = true, silent = true }

  -- Remove trailing whitespace
  -- i.e. one or more (`\+`) whitespace (`\s`) at end of line (`$`)
  sed([[\s\+$]], "", flags, mods)

  -- remove trailing empty lines
  -- i.e. one or more (`\+`) line breaks (`\n`) and the end of the file (`\%$`)
  sed([[\n\+\%$]], "", flags, mods)

  -- Restore cursor position
  vim.fn.winrestview(view)
end, { desc = "Trim trailing whitespace" })

command("Grep", function(opts)
  local grep_opts = {}
  if opts.bang then
    grep_opts.path = "."
  end
  require("rafik.grep").run(opts.fargs, grep_opts)
end, {
  desc = "Use ripgrep to search for a term",
  nargs = "+",
  bang = true,
  complete = "tag",
})

command("Sed", function(opts)
  local pattern = opts.fargs[1]
  local repl = opts.fargs[2]
  local flags = { unpack(opts.fargs, 3) }

  if repl == nil then
    vim.notify("Missing second argument", vim.log.levels.ERROR)
    return
  end

  if not opts.bang and vim.tbl_isempty(flags) then
    flags = nil
  end

  require("rafik.sed").run(pattern, repl, flags)
end, {
  desc = "Substitute pattern with a replacement string",
  bang = true, -- Can be set to avoid using the default "g" flag
  nargs = "+",
})

local git_jump_commands = { "diff", "staged", "merge" }
local git_jump_complete = function(arg_lead, cmdline)
  if #vim.split(cmdline, " ") <= 2 then
    return vim.tbl_filter(
      function(c) return vim.startswith(c, arg_lead) end,
      git_jump_commands
    )
  end
end
command("Jump", function(opts)
  local count
  if vim.v.count > 0 then
    -- called from mapping
    count = vim.v.count
  else
    -- called from command-line
    count = opts.count
  end

  local args
  if count > 0 then
    args = git_jump_commands[count]
  else
    args = opts.args
  end

  require("rafik.git").jump(args)
end, {
  desc = "`git jump` from within Vim",
  nargs = "*",
  count = 0,
  complete = git_jump_complete,
})

command("GBrowse", function(opts)
  local range = { start = opts.line1, finish = opts.line2 }
  require("rafik.git").gh_browse(opts.fargs, range)
end, {
  desc = "Use `gh browse` to view file and commits on GitHub",
  nargs = "*",
  range = true,
})

command("W", function() vim.cmd.write({ mods = { noautocmd = true } }) end, {
  desc = "Save buffer without running BufWrite/BufWritePost autocommands",
})
