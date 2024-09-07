local fzf = require("fzf-lua")

local M = {}
local h = {}

local state = {
  -- Indicates whether the repository paths should be included in the
  -- fuzzy-finder display or not. It can be toggled on-the-fly when the
  -- fuzzy-finder is active.
  display_path = false,
}

-- `switch` provides a fzf interface to select a git repository to work on.
--
-- The first screen lists candidate repositories. Pressing `<tab>` toggles the
-- display of the full path of the repository (which can be fuzzy-searched on).
-- After selecting one, the `git_files` fzf-lua command is invoked on it.
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

  local cmd = h.make_command(root, search_paths)
  fzf.fzf_exec(cmd, {
    actions = {
      -- select repo and fuzzy-search its files
      default = function(selected) h.act(selected[1], root) end,

      -- toggle display of full paths
      tab = {
        function() state.display_path = not state.display_path end,
        function() fzf.resume({ fzf_opts = h.fzf_opts(state.display_path) }) end,
      },
    },
    fn_transform = h.display,
    fzf_opts = h.fzf_opts(state.display_path),
    prompt = prompt .. "> ",
  })
end

-- Helpers --------------------------------------------------------------------

-- `make_command` returns the `fd` command used to list all git repositories
-- under the given `search_paths` in `root`. If `search_paths` is empty , then
-- it lists all git repositories under `root`.
h.make_command = function(root, search_paths)
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

  return vim.iter(cmd):flatten():join(" ")
end

-- `act` changes the local current working directory to the repository
-- corresponding to the selection, and triggers the built-in `git_files`
-- fzf-lua action for it.
--
-- `selection` will always be the full "<basename> <path>" entry, regardless of
-- the value of `state.display_path`.
h.act = function(selection, root)
  local basename, path = unpack(vim.split(selection, " "))
  if not path then
    vim.notify("Invalid selection: " .. selection, vim.log.levels.ERROR)
    return
  end

  if not vim.startswith(path, root) then
    path = string.format("%s/%s", root, path)
  end
  vim.cmd.lcd(path)
  fzf.git_files({ cwd = path, prompt = basename .. "> " })
end

-- `fzf_opts` returns the the appropriate options for fzf depending on whether
-- display_path is true or false.
--
-- If `display_path` is true, then we disable the `with_nth` option, so that it
-- shows the whole entries with their paths. Otherwise, we set it to 1, to
-- indicate that we only want to use the first (space-delimited) "field" of the
-- entries (i.e. the base names of the repositories).
h.fzf_opts = function(display_path)
  local with_nth = false
  if not display_path then
    with_nth = 1
  end
  return {
    ["--with-nth"] = with_nth,
  }
end

-- `display` takes the file path of a git repository, and renders it as
-- "<basename> <path>", where the base name is emphasized and the path is
-- muted.
h.display = function(path)
  local basename = vim.fs.basename(path)
  return string.format(
    "%s %s",
    fzf.utils.ansi_codes.bold(basename),
    fzf.utils.ansi_codes.grey(path)
  )
end

return M
