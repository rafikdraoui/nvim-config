local M = {}

M.ai = function()
  local ai_spec = require("mini.ai").gen_spec
  local tobj = require("lib.mini_tobj")

  require("mini.ai").setup({
    custom_textobjects = {
      c = tobj.treesitter({ a = "@class.outer", i = "@class.inner" }),
      e = tobj.entire,
      f = tobj.treesitter({ a = "@function.outer", i = "@function.inner" }),
      g = ai_spec.pair("«", "»"),
      i = tobj.indent,
      k = ai_spec.function_call(),
      l = tobj.line,
      n = { "%f[%d]%d+" }, -- decimal numbers
      t = "", -- use built-in tag text object
      u = tobj.url,
    },

    -- Remap to avoid conflicting with 'line' and 'number' text objects
    mappings = {
      around_next = "aN",
      inside_next = "iN",
      around_last = "aL",
      inside_last = "iL",
    },
  })
end

M.jump = function()
  require("mini.jump").setup({
    mappings = {
      repeat_jump = "",
    },
  })
end

M.surround = function()
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
end

return M
