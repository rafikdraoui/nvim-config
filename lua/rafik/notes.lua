local MiniPick = require("mini.pick")

local M = {}
local h = {}

M.edit = function(root)
  root = h.ensure_root(root)
  MiniPick.builtin.files({ tool = "fd" }, {
    source = {
      name = "Notes",
      cwd = root,
      show = MiniPick.default_show,
    },
    mappings = {
      choose = "", -- override with "edit_or_create"
      edit_or_create = {
        char = "<cr>",
        func = function()
          local selected = MiniPick.get_picker_matches().current
          if selected then
            MiniPick.default_choose(selected)
          else
            h.create_note_from_query(root)
          end
          return true
        end,
      },
      toggle_exact_matching = {
        char = "<c-e>",
        func = function()
          local query = MiniPick.get_picker_query()
          if query[1] == "'" then
            table.remove(query, 1)
          else
            table.insert(query, 1, "'")
          end
          MiniPick.set_picker_query(query)
        end,
      },
      create_new_note_from_query = {
        char = "<c-o>",
        func = function()
          h.create_note_from_query(root)
          return true
        end,
      },
      search_mode = {
        char = "<c-/>",
        func = function()
          local query = MiniPick.get_picker_query()
          M.search(root)
          vim.defer_fn(function() MiniPick.set_picker_query(query) end, 100)
        end,
      },
    },
  })
end

M.search = function(root)
  root = h.ensure_root()
  MiniPick.builtin.grep_live({ tool = "rg" }, {
    source = {
      name = "Search notes",
      cwd = root,
      show = MiniPick.default_show,
    },
    mappings = {
      edit_mode = {
        char = "<c-/>",
        func = function()
          local query = MiniPick.get_picker_query()
          M.edit(root)
          vim.defer_fn(function() MiniPick.set_picker_query(query) end, 100)
        end,
      },
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

h.create_note_from_query = function(root)
  local query = MiniPick.get_picker_query()
  if #query == 0 then
    return true
  end
  local name = vim.fn.join(query, "")
  local path = vim.fs.joinpath(root, name)

  local win_id = MiniPick.get_picker_state().windows.target
  vim.api.nvim_win_call(win_id, function() vim.cmd.edit(path) end)
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
