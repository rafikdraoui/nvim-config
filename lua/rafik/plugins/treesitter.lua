vim.cmd.packadd("nvim-treesitter")
vim.cmd.packadd("nvim-treesitter-locals")
vim.cmd.packadd("nvim-treesitter-textobjects")

require("nvim-treesitter.configs").setup({
  parser_install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site"),
  highlight = {
    enable = true,
    disable = {
      "dockerfile",
      "just",
    },
  },
  textobjects = {
    move = {
      enable = true,
      goto_next_start = {
        ["]f"] = "@function.outer",
        ["]]"] = "@class.outer",
      },
      goto_next_end = {
        ["]F"] = "@function.outer",
        ["]["] = "@class.outer",
      },
      goto_previous_start = {
        ["[f"] = "@function.outer",
        ["[["] = "@class.outer",
      },
      goto_previous_end = {
        ["[F"] = "@function.outer",
        ["[]"] = "@class.outer",
      },
    },
  },
})

vim.keymap.set(
  "n",
  "g:",
  function() print(require("nvim-treesitter").statusline()) end,
  { desc = "Display current position in parse tree" }
)

vim.keymap.set(
  "n",
  "cot",
  function() vim.cmd.TSBufToggle("highlight") end,
  { desc = "Toggle tree-sitter highlighting" }
)

-- Add grammar for Jujutsu's commit messages filetype
local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.jjdescription = {
  install_info = {
    url = "https://github.com/kareigu/tree-sitter-jjdescription.git",
    files = { "src/parser.c" },
    branch = "dev",
  },
  filetype = "jj",
}

-- Go to next/previous local usage of variable under the cursor.
-- Depends on `nvim-treesitter-locals`.
local goto_adjacent_usage = function(delta)
  local current_node = vim.treesitter.get_node()
  if not current_node then
    return
  end

  -- Find all usages of current node in the function scope, and get their
  -- (0,0)-based positions.
  local ts_locals = require("nvim-treesitter-locals.locals")
  local scopes = ts_locals.get_scope_tree(current_node, 0)
  local scope = current_node:tree():root()
  for _, s in ipairs(scopes) do
    if s:type() == "function_definition" then
      scope = s
    end
  end
  local usages = ts_locals.find_usages(current_node, scope)
  local positions = vim.tbl_map(function(n)
    local row, col, _ = n:start()
    return { row = row, col = col }
  end, usages)

  -- Determine which usage to jump to, based on the position of the current
  -- node under the cursor.
  local target_index = nil -- index of target node position in `positions`
  local current_node_row, current_node_col, _ = current_node:start()
  for i, pos in ipairs(positions) do
    if pos.row == current_node_row and pos.col == current_node_col then
      target_index = i + delta
    end
  end
  if target_index == nil then
    return
  end
  -- wrap around
  if target_index > #positions then
    target_index = 1
  elseif target_index < 1 then
    target_index = #positions
  end

  -- Jump to the target node. We need to convert the position to be (1,0)-based
  -- for `nvim_win_set_cursor`.
  local target_pos = positions[target_index]
  vim.api.nvim_win_set_cursor(0, { target_pos.row + 1, target_pos.col })
end

vim.keymap.set(
  "n",
  "<a-n>",
  function() goto_adjacent_usage(1) end,
  { desc = "Jump to next usage of variable under the cursor" }
)
vim.keymap.set(
  "n",
  "<a-N>",
  function() goto_adjacent_usage(-1) end,
  { desc = "Jump to previous usage of variable under the cursor" }
)
