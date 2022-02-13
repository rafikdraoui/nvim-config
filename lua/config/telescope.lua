local telescope = require("telescope")

telescope.setup({
  defaults = {
    borderchars = {
      { "─", "│", "─", "│", "┌", "┐", "┘", "└" },
      results = { "─", "│", "─", "│", "├", "┤", "┘", "└" },
    },
    layout_config = {
      center = {
        -- set a maximum width of 80 and a minimum horizontal padding of 2
        width = function(_, columns)
          return math.min(80, columns - 4)
        end,
      },
    },
    layout_strategy = "center",
    mappings = {
      i = {
        ["<esc>"] = "close",

        -- restore readline-style binding for clearing line
        ["<c-u>"] = false,
      },
    },
    preview = false,
    sorting_strategy = "ascending",
  },
})

telescope.load_extension("fzf")
