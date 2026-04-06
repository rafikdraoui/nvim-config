local MiniPick = require("mini.pick")

local M = {}
local h = {}

local state = {
  -- Indicates whether the repository paths should be included in the
  -- fuzzy-finder display or not. It can be toggled on-the-fly when the
  -- fuzzy-finder is active.
  display_path = false,
}

-- `switch` provides a MiniPick picker to select a git repository to work on.
--
-- The first screen lists candidate repositories. Pressing `<tab>` toggles the
-- display of the full path of the repository (which can be fuzzy-searched on).
-- After selecting one, the `git_files` built-in picker is invoked on it.
--
-- It takes an optional `opts` table with keys `prompt`, `root`, and
-- `search_paths`, all of which are optional.
--
-- `search_paths` should be a list of paths to directories in which to search
-- for repositories. If a path isn't absolute, then it is considered to be
-- relative to `root`. If the list is empty, then all directories of `root` are
-- searched. If `root` is not provided, then it defaults to `$HOME`.
--
-- Examples:
--    Search for repositories in ~/:
--      switch()
--
--    Search for repositories in `~/dotfiles` and `~/projects`:
--      switch({ search_paths = { "dotfiles", "projects" } })
--
--    Search for repositories in `~/code`:
--      switch({ root = vim.env.HOME .. "/code" })
--
--    Search for repositories in `~/code/dotfiles` and `~/code/projects`:
--      switch({
--        root = vim.env.HOME .. "/code",
--        search_paths = { "dotfiles", "projects" },
--      })
--
--    Search for repositories in `~/.local/share/nvim/site/pack` and
--    `/usr/local/share` (`root` is ignored when a search path is absolute):
--      switch({
--        root = vim.fn.stdpath("data"),
--        search_paths = { "site/pack", "/usr/local/share" },
--      })
M.switch = function(opts)
  opts = opts or {}
  local prompt = opts.prompt or "Repos"
  local root = opts.root or vim.env.HOME
  local search_paths = opts.search_paths or {}

  local cmd = h.command(root, search_paths)
  MiniPick.builtin.cli({ command = cmd }, {
    source = {
      name = prompt,
      cwd = root,
      show = h.show,
      choose = h.choose,
    },
    mappings = {
      toggle_preview = "",
      toggle_display_path = {
        char = "<tab>",
        func = function() state.display_path = not state.display_path end,
      },
    },
  })
end

-- Helpers --------------------------------------------------------------------

h.show = function(buf_id, items_to_show, query)
  local items = vim.tbl_map(function(path)
    local basename = vim.fs.basename(path)
    if state.display_path then
      return string.format("%s (%s)", basename, path)
    else
      return basename
    end
  end, items_to_show)
  return MiniPick.default_show(buf_id, items, query)
end

-- `choose` triggers the built-in `git_files` picker for the selected item,
-- which should be the path to a Git repository.
h.choose = function(item)
  local repo_path = vim.fs.abspath(item)
  local repo_name = vim.fs.basename(repo_path)
  MiniPick.builtin.files({ tool = "git" }, {
    source = { cwd = repo_path, name = repo_name, show = MiniPick.default_show },
  })
end

-- `command` returns the `fd` command used to list all git repositories
-- under the given `search_paths` in `root`. If `search_paths` is empty , then
-- it lists all git repositories under `root`.
h.command = function(root, search_paths)
  local cmd = {
    "fd",
    ".git", -- file name pattern to search for
    "--glob", -- match pattern on the exact name rather than regex
    "--hidden", -- ensure that hidden files are included in search
    { "--base-directory", root }, -- use `root` as cwd for search
  }

  -- restrict search to the following paths
  for _, p in ipairs(search_paths) do
    table.insert(cmd, { "--search-path", p })
  end

  -- displays the parent directories of matches as the search results
  -- e.g. `/home/user/hello/.git` -> `/home/user/hello`
  table.insert(cmd, { "--exec", "echo", "{//}" })

  return vim.iter(cmd):flatten():totable()
end

return M
