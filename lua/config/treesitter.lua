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
