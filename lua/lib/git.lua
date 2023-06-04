local M = {}

-- Return the path of the root of the git repository of the current file (if
-- applicable)
M.root = function()
  local buf_dir = vim.fn.expand("%:p:h")
  local git_dir = vim.fs.find(".git", { path = buf_dir, upward = true })[1]
  if git_dir == nil then
    return nil
  end
  -- the first `:h` removes the trailing slash, the second one removes `.git`
  return vim.fn.fnamemodify(git_dir, ":p:h:h")
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

return M
