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
  require("lib/scratch").create(lines)
end, {
  desc = "Redirect output of Ex command into a scratch buffer",
  nargs = "+",
  complete = "command",
})

command("PackSync", function()
  require("plugins")
  vim.cmd.PackerSync()
end, { desc = "Load packer configuration and run PackerSync" })

command("ToSystemClipboard", function()
  local last_yank = vim.fn.getreginfo("@")
  vim.fn.setreg("+", last_yank)
end, { desc = "Copy last yank to system clipboard" })

command(
  "CdRoot",
  function() require("lib/git").cd_root() end,
  { desc = "Set cwd to root of git repository (if applicable)" }
)

command(
  "CdBuffer",
  function() vim.cmd.cd("%:p:h") end,
  { desc = "Set cwd to directory containing the file loaded in buffer" }
)

-- This is mostly needed to support Fugitive's `:GBrowse`
command("Browse", function(opts) require("lib/browse").url(opts.args) end, {
  desc = "Open web browser at given URL (or URL under cursor if no argument is given)",
  nargs = "?",
})

command(
  "GoDoc",
  function(opts) require("lib/browse").golang_docs(opts.fargs[1]) end,
  { desc = "Browse Go documentation", nargs = "*" }
)

command(
  "PyDoc",
  function(opts) require("lib/browse").python_docs(opts.fargs[1]) end,
  { desc = "Browse Python documentation", nargs = "*" }
)

command("Lint", function() require("lint").try_lint() end, { desc = "Lint file" })

command("TrimWhitespace", function()
  local sed = require("lib/sed").run

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

command("MaybeFormat", function()
  if vim.g.enable_formatting then
    local formatter_filetypes = vim.g.formatter_filetypes or {}
    if vim.tbl_contains(formatter_filetypes, vim.o.filetype) then
      vim.cmd.FormatWrite()
    end
  end
end, { desc = "Format buffer if enabled" })

command(
  "Grep",
  function(opts) require("lib/grep").run(opts.fargs, { use_cwd = opts.bang }) end,
  {
    desc = "Use ripgrep to search for a term. The query is added to the search register and search history",
    nargs = "+",
    bang = true,
    complete = "tag",
  }
)

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

  require("lib/sed").run(pattern, repl, flags)
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

  require("lib/git").jump(args)
end, {
  desc = "`git jump` from within Vim",
  nargs = "*",
  count = 0,
  complete = git_jump_complete,
})
