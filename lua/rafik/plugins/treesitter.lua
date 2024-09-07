vim.cmd.packadd("nvim-treesitter")
vim.cmd.packadd("nvim-treesitter-refactor")
vim.cmd.packadd("nvim-treesitter-textobjects")

require("nvim-treesitter.configs").setup({
  highlight = { enable = true },
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
  refactor = {
    navigation = {
      enable = true,
      keymaps = {
        goto_next_usage = "<a-n>",
        goto_previous_usage = "<a-N>",
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
  "coh",
  function() vim.cmd.TSBufToggle("highlight") end,
  { desc = "Toggle tree-sitter highlighting" }
)
