local treesitter = require("lib.ai_spec").treesitter

vim.b.miniai_config = {
  custom_textobjects = {
    -- Use tree-sitter for matching tags
    t = treesitter({ a = "@function.outer", i = "@function.inner" }),
  },
}
