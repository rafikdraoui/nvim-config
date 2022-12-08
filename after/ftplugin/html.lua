local tobj = require("lib.mini_tobj")

vim.b.miniai_config = {
  custom_textobjects = {
    -- Use tree-sitter for matching tags
    t = tobj.treesitter({ a = "@function.outer", i = "@function.inner" }),
  },
}
