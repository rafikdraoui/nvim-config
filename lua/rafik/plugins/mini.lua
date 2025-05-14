-- vim: foldmethod=marker

vim.cmd.packadd("mini.nvim")

-- mini-ai -------------------------------------------------------------------- {{{1
local ai_spec = require("mini.ai").gen_spec
local extra_ai_spec = require("mini.extra").gen_ai_spec
local custom_ai_spec = require("rafik.ai_spec")

local specs = {
  buffer = extra_ai_spec.buffer,
  function_call = ai_spec.function_call,
  indent = custom_ai_spec.indent,
  line = extra_ai_spec.line,
  number = extra_ai_spec.number,
  pair = ai_spec.pair,
  treesitter = custom_ai_spec.treesitter,
  url = custom_ai_spec.url,
}

require("mini.ai").setup({
  custom_textobjects = {
    c = specs.treesitter({ a = "@class.outer", i = "@class.inner" }),
    e = specs.buffer(),
    f = specs.treesitter({ a = "@function.outer", i = "@function.inner" }),
    g = specs.pair("«", "»"),
    i = specs.indent(),
    k = specs.function_call(),
    l = specs.line(),
    n = specs.number(),
    t = "", -- use built-in tag text object
    u = specs.url(),
  },

  -- Remap to avoid conflicting with 'line' and 'number' text objects
  mappings = {
    around_next = "aN",
    inside_next = "iN",
    around_last = "aL",
    inside_last = "iL",
  },
})

-- mini-bracketed ------------------------------------------------------------- {{{1

local MiniBracketed = require("mini.bracketed")

-- Force no-wrapping for all targets
local default_advance = MiniBracketed.advance
local nowrap_advance = function(iterator, direction, opts)
  opts.wrap = false
  return default_advance(iterator, direction, opts)
end
MiniBracketed.advance = nowrap_advance

MiniBracketed.setup({
  diagnostic = { options = { float = false } },
  file = { suffix = "n" },
  treesitter = { suffix = "" },
})

-- mini-diff ------------------------------------------------------------------ {{{1
local MiniDiff = require("mini.diff")

MiniDiff.setup({
  view = {
    style = "sign",
    signs = { add = "▍", change = "▍", delete = "▁▁" },
  },
})

vim.keymap.set(
  "n",
  "<leader>go",
  MiniDiff.toggle_overlay,
  { desc = "Toggle diff overlay" }
)

-- mini-files ----------------------------------------------------------------- {{{1
local MiniFiles = require("mini.files")

MiniFiles.setup({
  content = {
    -- Disable icons
    prefix = function() end,
  },
  mappings = {
    -- Open file and close explorer
    go_in_plus = "<cr>",
  },
})

vim.keymap.set("n", "-", function()
  local path = vim.api.nvim_buf_get_name(0)
  if not vim.uv.fs_stat(path) then
    path = vim.fn.fnamemodify(path, ":p:h")
  end
  MiniFiles.open(path)
end, { desc = "Open file explorer (in directory of current file)" })

-- mini-git ------------------------------------------------------------------- {{{1
local MiniGit = require("mini.git")
MiniGit.setup()

vim.keymap.set(
  { "n", "x" },
  "<leader>gg",
  MiniGit.show_at_cursor,
  { desc = "Show git info at cursor" }
)

-- mini-hipatterns ------------------------------------------------------------ {{{1
local MiniHiPatterns = require("mini.hipatterns")
MiniHiPatterns.setup({
  highlighters = {
    hex_color = MiniHiPatterns.gen_highlighter.hex_color(),
  },
})

vim.keymap.set(
  "n",
  "coh",
  MiniHiPatterns.toggle,
  { desc = "Toggle highlighting of patterns" }
)

-- mini-jump ------------------------------------------------------------------ {{{1
require("mini.jump").setup({
  silent = true, -- suppress printing of warning messages
})

-- mini-move ------------------------------------------------------------------ {{{1
local move = {
  left = "<s-left>",
  right = "<s-right>",
  down = "<s-down>",
  up = "<s-up>",
}
require("mini.move").setup({
  mappings = {
    left = move.left,
    right = move.right,
    down = move.down,
    up = move.up,

    line_left = move.left,
    line_right = move.right,
    line_down = move.down,
    line_up = move.up,
  },
})

-- mini-operators ------------------------------------------------------------- {{{1
require("mini.operators").setup({
  exchange = { prefix = "cx" },
  replace = { prefix = "s" },
  sort = {
    -- Use our own custom sort operator instead to avoid surprising behaviour
    -- with linewise vs charwise motions.
    -- c.f. https://github.com/echasnovski/mini.nvim/issues/439#issuecomment-1686896019
    prefix = "",
  },
})

-- mini-pick ------------------------------------------------------------------ {{{1
local MiniPick = require("mini.pick")
MiniPick.setup({
  mappings = {
    send_to_quickfix = {
      char = "<c-q>",
      func = function()
        vim.api.nvim_input("<c-a>") -- mark all
        vim.api.nvim_input("<a-cr>") -- choose marked
      end,
    },
  },
})
-- Enable extra pickers
require("mini.extra").setup()

vim.ui.select = MiniPick.ui_select

vim.keymap.set(
  "n",
  "<leader>c",
  MiniPick.registry.diagnostic,
  { desc = "Show diagnostics in mini picker" }
)

-- mini-surround -------------------------------------------------------------- {{{1
require("mini.surround").setup({
  custom_surroundings = {
    g = { output = { left = "«", right = "»" } },
  },

  -- Remap to avoid conflicting with 'line' and 'number' text objects
  mappings = {
    suffix_last = "L",
    suffix_next = "N",
  },
})
