local M = {}
local h = {}

-- Return the path of the root of the git repository of the current file (if
-- applicable)
M.root = function()
  -- We compute `buf_dir` and pass it to `vim.fs.root` so that it works with
  -- unnamed buffers.
  local buf_dir = vim.fn.expand("%:p:h")
  return vim.fs.root(buf_dir, ".git")
end

-- Change the current working directory to the root of the git repository (if
-- applicable)
M.cd_root = function()
  local root = M.root()
  if root then
    vim.cmd.cd(root)
  end
end

-- Run `git-jump`, and load the results in the quickfix list
M.jump = function(args)
  if args == nil or args == "" then
    args = "diff"
  end
  if args == "staged" then
    args = "diff --cached"
  end
  local system_cmd = string.format("system('git jump --stdout %s')", args)
  vim.cmd.cexpr(system_cmd)
end

-- Run `gh browse` to view commit, file, or repository on GitHub
M.gh_browse = function(args, range)
  if #args == 0 then
    args = h.get_gh_browse_args(range)
  end

  local cmd = vim.list_extend({ "gh", "browse" }, args)
  vim.system(cmd, { cwd = M.root(), detach = true }, function(result)
    local notify = vim.schedule_wrap(vim.notify)
    local cmd_string = vim.iter(cmd):join(" ")
    if result.code == 0 then
      notify(cmd_string)
    else
      local msg = string.format("error executing %q: %s", cmd_string, result.stderr)
      notify(msg, vim.log.levels.WARN)
    end
  end)
end

-- Infer which arguments to pass to `gh browse` based on context
h.get_gh_browse_args = function(range)
  -- If word under the cursor looks like a commit hash, use it has the object
  -- to browse
  local cword = vim.fn.expand("<cword>")
  if string.find(cword, "^%x%x%x%x%x%x+$") ~= nil then
    return { cword }
  end

  -- If the current file is tracked in git, then use it as the object to browse
  local buf_git_data = require("mini.git").get_buf_data() or {}
  if not vim.tbl_isempty(buf_git_data) then
    -- make file path relative to repository root
    local repo_path_length = #buf_git_data.root + 1 -- we add 1 to include trailing slash
    local filepath = string.sub(vim.fn.expand("%:p"), repo_path_length + 1)
    -- append line numbers range to file path
    local filespec = string.format("%s:%s-%s", filepath, range.start, range.finish)
    return { "--branch", buf_git_data.head_name, filespec }
  end

  -- If the current buffer is a special git buffer, then find the first thing
  -- that looks like a commit hash, and use is as the object to browse
  if vim.startswith(vim.bo.filetype, "git") then
    vim.fn.cursor(1, 1)
    if vim.fn.search([[\x\{6,\}]]) ~= 0 then
      return { vim.fn.expand("<cword>") }
    end
  end

  -- If none of the above applies, we will run `gh browse` without arguments,
  -- which will browse to the main page of the repository on GitHub.
  return {}
end

return M
