local fzf = require("fzf-lua")

local M = {}
local h = {}

M.edit = function(root, query)
  root = h.ensure_root(root)

  local exact_match = false
  fzf.files({
    cwd = root,
    cwd_prompt = false,
    header = false,
    prompt = "Notes> ",
    query = query,
    actions = {
      -- edit or create note
      ["return"] = function(selected, opts)
        if #selected > 0 then
          fzf.actions.file_edit_or_qf(selected, opts)
        else
          h.create_note_from_query(root)
        end
      end,

      -- toggle exact matching
      ["ctrl-e"] = {
        function() exact_match = not exact_match end,
        function() fzf.resume({ fzf_opts = { ["--exact"] = exact_match } }) end,
      },

      -- create new note with name set to the current query
      ["ctrl-o"] = function() h.create_note_from_query(root) end,

      -- switch to search mode
      ["ctrl-s"] = function() M.search(root, h.query()) end,
    },
  })
end

M.search = function(root, query)
  root = h.ensure_root()

  fzf.live_grep_native({
    cwd = root,
    prompt = "Search notes> ",
    query = query,
    fzf_opts = {
      -- exclude file names from search
      ["--nth"] = "2..",
    },
    actions = {
      -- switch to edit mode
      ["ctrl-s"] = function() M.edit(root, h.query()) end,
    },
  })
end

M.jump = function(root)
  root = h.ensure_root()

  local tag = h.target_at_cursor(M.tag_pattern)
  if tag then
    require("rafik.grep").run(
      { "--fixed-strings", "--sort", "path", tag },
      { path = root }
    )
    return
  end

  local link = h.target_at_cursor(M.link_pattern)
  if link then
    vim.cmd.edit(vim.fs.joinpath(root, string.sub(link, 2, -2)))
    return
  end

  vim.notify("notes: no target under cursor")
end

M.link_pattern = "|%S.-%S|"

M.tag_pattern = ":%S%S-:"

-- Helpers --------------------------------------------------------------------

h.ensure_root = function(root)
  root = root or vim.env.NOTES_DIR
  if not root then
    error("root directory is not set", 0)
  end
  return root
end

h.query = fzf.get_last_query

h.create_note_from_query = function(root)
  local filename = h.query()
  vim.cmd.edit(vim.fs.joinpath(root, filename))
end

h.target_at_cursor = function(pattern)
  local pos = vim.fn.getpos(".")
  local lnum, col = pos[2], pos[3]
  local line = vim.fn.getline(lnum)

  local i = 1
  for match in string.gmatch(line, pattern) do
    local m_start, m_end = string.find(line, match, i, true)
    if m_start <= col and m_end >= col then
      return match
    end
    i = m_end
  end
  return nil
end

h.err_wrap = function(f)
  return function(...)
    local ok, err = pcall(f, ...)
    if not ok then
      vim.notify("notes: " .. err, vim.log.levels.ERROR)
    end
  end
end

M = vim.tbl_map(function(v)
  if type(v) == "function" then
    v = h.err_wrap(v)
  end
  return v
end, M)
return M
