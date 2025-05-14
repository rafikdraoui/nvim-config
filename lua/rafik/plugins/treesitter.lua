vim.cmd.packadd("nvim-treesitter")
vim.cmd.packadd("nvim-treesitter-refactor")
vim.cmd.packadd("nvim-treesitter-textobjects")

require("nvim-treesitter.configs").setup({
  parser_install_dir = vim.fs.joinpath(vim.fn.stdpath("data"), "site"),
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
        list_definitions_toc = false,
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
