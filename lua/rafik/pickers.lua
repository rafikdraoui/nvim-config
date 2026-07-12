local MiniPick = require("mini.pick")

local M = {}

M.dotfiles = function()
  MiniPick.builtin.files({ tool = "git" }, {
    source = {
      cwd = vim.fs.joinpath(vim.env.HOME, "dotfiles"),
      name = "Dotfiles",
      show = MiniPick.default_show,
    },
  })
end

M.files = function(tool, root_dir)
  local repo_root = require("rafik.git").root()
  root_dir = root_dir or repo_root
  tool = tool or "git"
  if not repo_root then
    tool = "fd"
  end

  MiniPick.builtin.files({ tool = tool }, {
    source = {
      cwd = root_dir,
      name = string.format("Files (%s)", tool),
      show = MiniPick.default_show,
    },
    mappings = {
      move_start = "", -- override with "toggle root vs cwd"
      ["toggle repo root vs cwd"] = {
        char = "<c-g>",
        func = function()
          local new_root
          if root_dir == repo_root then
            local target_win = MiniPick.get_picker_state().windows.target
            new_root = vim.fn.getcwd(target_win)
          else
            new_root = repo_root
          end
          tool = tool == "git" and "fd" or "git"
          M.files(tool, new_root)
        end,
      },
      set_root_to_buffer_dir = {
        char = "<c-/>",
        func = function()
          local target_win = MiniPick.get_picker_state().windows.target
          local bufnr = vim.api.nvim_win_get_buf(target_win)
          local buf_name = vim.api.nvim_buf_get_name(bufnr)
          local buf_dir = vim.fs.dirname(buf_name)
          M.files("fd", buf_dir)
        end,
      },
      set_root_to_parent = {
        char = "<c-up>",
        func = function()
          local parent_dir = vim.fs.dirname(root_dir)
          M.files("fd", parent_dir)
        end,
      },
      set_root_to_child = {
        char = "<c-down>",
        func = function()
          local current = MiniPick.get_picker_matches().current
          local parts = vim.split(current, "/")
          if #parts == 1 then
            return
          end
          local child_dir = vim.fs.joinpath(root_dir, parts[1])
          M.files("fd", child_dir)
        end,
      },
    },
  })
end

M.helptags = function()
  local show_help = function(buf_id, items_to_show, query)
    local items = vim.tbl_map(function(item)
      local pad = vim.o.columns > 115 and 65 or 45
      item.text =
        string.format("%-" .. pad .. "s %s", item.name, vim.fs.basename(item.filename))
      return item
    end, items_to_show)
    return MiniPick.default_show(buf_id, items, query)
  end
  MiniPick.builtin.help({}, { source = { show = show_help } })
end

return M
