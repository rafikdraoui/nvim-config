local M = {}

M.ghostty_scrollback = {
  -- Fold expression for Ghostty scrollback buffer that folds on command line
  -- prompts
  foldexpr = function(lnum)
    local next_line = vim.fn.getline(lnum + 1)
    if vim.startswith(next_line, "» ") then
      -- Command line prompt: start a new fold.
      return ">1"
    else
      -- In command output: keep fold level.
      return "1"
    end
  end,

  -- Display command as the fold text
  foldtext = function() return vim.fn.getline(vim.v.foldstart + 1) end,
}

M.diff = {
  foldexpr = function(lnum)
    local line = vim.fn.getline(lnum)
    if vim.startswith(line, "#") then
      -- Git commit preamble: do not fold.
      return 0
    end

    if vim.startswith(line, "diff --git") then
      -- Start of a new file diff: start a new fold.
      return ">1"
    else
      -- In a file diff: keep fold level.
      return "1"
    end
  end,

  foldtext = function()
    local first_line = vim.fn.getline(vim.v.foldstart)
    if not vim.startswith(first_line, "diff --git") then
      return vim.fn.foldtext()
    end

    -- Extract path/to/file from a line of the form:
    -- diff --git a/path/to/file b/path/to/file
    local filename = first_line:match("^diff %-%-git a/(.+) b/%1$")
    if not filename then
      -- Fallback to the last word stripped of its `b/` prefix
      filename = first_line:match("%S+$"):sub(3)
    end

    local add, remove = 0, 0
    local in_hunk = false
    local prefix = "+" .. vim.v.folddashes
    for lnum = vim.v.foldstart + 1, vim.v.foldend do
      local line = vim.fn.getline(lnum)

      if vim.startswith(line, "Binary") then
        return string.format("%s %s (binary)", prefix, filename)
      end

      if vim.startswith(line, "@@") then
        in_hunk = true
      elseif in_hunk and vim.startswith(line, "+") then
        add = add + 1
      elseif in_hunk and vim.startswith(line, "-") then
        remove = remove + 1
      end
    end

    return string.format("%s %s: +%d -%d", prefix, filename, add, remove)
  end,
}

return M
