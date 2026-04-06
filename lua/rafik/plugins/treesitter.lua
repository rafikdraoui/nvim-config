vim.cmd.packadd("nvim-treesitter")
vim.cmd.packadd("nvim-treesitter-context")
vim.cmd.packadd("nvim-treesitter-locals")
vim.cmd.packadd("nvim-treesitter-textobjects")

-- Enable tree-sitter when opening a file for a supported language
local installed_parsers = require("nvim-treesitter").get_installed()
local filetypes = {}
for _, parser in ipairs(installed_parsers) do
  for _, ft in ipairs(vim.treesitter.language.get_filetypes(parser)) do
    table.insert(filetypes, ft)
  end
end
vim.api.nvim_create_autocmd("FileType", {
  pattern = filetypes,
  group = vim.api.nvim_create_augroup("nvim-treesitter-filetypes", { clear = true }),
  desc = "Start tree-sitter for supported filetypes",
  callback = function(ev) vim.treesitter.start(ev.buf) end,
})

-- Add mappings to navigate to next/previous function/class
local ts_move_map = function(lhs, method, target)
  vim.keymap.set(
    { "n", "x", "o" },
    lhs,
    function() require("nvim-treesitter-textobjects.move")[method](target, "textobjects") end,
    { desc = string.format("%s %s", method, target) }
  )
end
ts_move_map("]f", "goto_next_start", "@function.outer")
ts_move_map("[f", "goto_previous_start", "@function.outer")
ts_move_map("]F", "goto_next_end", "@function.outer")
ts_move_map("[F", "goto_previous_end", "@function.outer")
ts_move_map("]]", "goto_next_start", "@class.outer")
ts_move_map("[[", "goto_previous_start", "@class.outer")

-- Add mapping to toggle tree-sitter highlighting
local ts_toggle = function()
  local bufnr = vim.fn.bufnr()
  local active = vim.treesitter.highlighter.active[bufnr]
  if active then
    vim.treesitter.stop()
  else
    vim.treesitter.start()
  end
  print(string.format("tree-sitter highlight: %s", not active))
end
vim.keymap.set(
  "n",
  "<localleader>t",
  ts_toggle,
  { desc = "Toggle tree-sitter highlighting" }
)

-- Install additional parsers
vim.api.nvim_create_autocmd("User", {
  pattern = "TSUpdate",
  desc = "Install custom tree-sitter parsers",
  group = vim.api.nvim_create_augroup("nvim-treesitter-custom", { clear = true }),
  callback = function()
    require("nvim-treesitter.parsers").d2 = {
      install_info = {
        url = "https://github.com/ravsii/tree-sitter-d2",
        revision = "ffb66ce4c801a1e37ed145ebd5eca1ea8865e00f",
        queries = "queries",
      },
    }
  end,
})

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

require("treesitter-context").setup({
  enable = false, -- disable by default
  multiline_threshold = 1, -- only show one line per context
})
vim.keymap.set("n", "<localleader>i", function()
  local ts_context = require("treesitter-context")
  ts_context.toggle()
  print(string.format("tree-sitter context: %s", ts_context.enabled()))
end, { desc = "Toggle treesitter-context" })
