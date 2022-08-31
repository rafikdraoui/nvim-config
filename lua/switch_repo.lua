local action_state = require("telescope.actions.state")
local actions = require("telescope.actions")
local conf = require("telescope.config").values
local finders = require("telescope.finders")
local pickers = require("telescope.pickers")

local M = {}

local BASE_DIRECTORY = vim.env.HOME
local DEFAULT_SEARCH_PATHS_CONFIG = "switch_repo_search_paths"

local PATH_DISPLAY = { none = "none", shortened = "shortened", full = "full" }
local current_path_display = PATH_DISPLAY.none

-- `cycle_path_display` sets the current path display to the next available
-- option.
local cycle_path_display = function()
  local cycle = {
    PATH_DISPLAY.none,
    PATH_DISPLAY.shortened,
    PATH_DISPLAY.full,
  }
  vim.tbl_add_reverse_lookup(cycle)

  local i = cycle[current_path_display] + 1
  if i > #cycle then
    i = 1
  end
  current_path_display = cycle[i]
end

-- `make_command` returns the `fd` command used to list all git repositories
-- under the given `search_paths`. If `search_paths` is empty or nil, then it
-- lists all git repositories under `BASE_DIRECTORY`.
local make_command = function(search_paths)
  local search_pattern = [[^\.git$]]
  local cmd = {
    "fd",
    "--hidden",
    { "--type", "directory" },
    { "--base-directory", BASE_DIRECTORY },
    { "--exec", "echo", "{//}", ";" },
  }
  for _, p in ipairs(search_paths) do
    table.insert(cmd, { "--search-path", p })
  end
  table.insert(cmd, search_pattern)
  return vim.tbl_flatten(cmd)
end

-- `make_entry` is the Telescope entry maker used by the switch_repo picker. It
-- uses the base name of the path of the git repository (i.e. the name of the
-- directory that contains the `.git` directory) as the display value,
-- optionally adding the shortened or full path depending on the value of
-- `current_path_display`.
local make_entry = function(entry)
  local path_display = ""
  if current_path_display == PATH_DISPLAY.shortened then
    path_display = string.format("(%s)", vim.fn.pathshorten(entry))
  elseif current_path_display == PATH_DISPLAY.full then
    path_display = string.format("(%s)", entry)
  end

  local basename = vim.fs.basename(entry)
  local display = string.format("%s %s", basename, path_display)

  return {
    value = entry,
    display = display,
    ordinal = display,
    basename = basename,
  }
end

-- `on_select` is run when an entry is selected. It closes the prompt, changes
-- the local current working directory to the path of the selected entry, and
-- runs the builtin `git_files` picker in that directory.
local on_select = function(prompt_bufnr)
  actions.close(prompt_bufnr)
  local selection = action_state.get_selected_entry()
  if selection == nil then
    return
  end
  local dir = selection.value
  if not vim.startswith(dir, BASE_DIRECTORY) then
    dir = string.format("%s/%s", BASE_DIRECTORY, dir)
  end
  vim.cmd.lcd(dir)
  require("telescope.builtin").git_files({ prompt_title = selection.basename })
end

-- `switch` is a Telescope picker used to select a git repository to work on.
-- By default, it looks for repositories in the list of folders given by
-- `opts.search_paths`, falling back to `vim.g.switch_repo_search_paths`. If
-- neither of those are given, then the picker looks for every git repository
-- under $HOME.
M.switch = function(opts)
  opts = opts or {}
  opts.entry_maker = make_entry
  local search_paths = opts.search_paths or vim.g[DEFAULT_SEARCH_PATHS_CONFIG] or {}
  local cmd = make_command(search_paths)

  pickers
    .new(opts, {
      prompt_title = "Repos",
      finder = finders.new_oneshot_job(cmd, opts),
      sorter = conf.file_sorter(opts),
      attach_mappings = function(prompt_bufnr, map)
        actions.select_default:replace(function() on_select(prompt_bufnr) end)

        map("i", "<tab>", function()
          cycle_path_display()
          local picker = action_state.get_current_picker(prompt_bufnr)
          picker:refresh(finders.new_oneshot_job(cmd, opts))
        end)

        return true
      end,
    })
    :find()
end

return M
