vim.diagnostic.config({
  float = {
    format = function(d)
      -- Include error code in diagnostic (if available)
      if d.code then
        return string.format("%s: %s [%s]", d.source, d.message, d.code)
      else
        return string.format("%s: %s", d.source, d.message)
      end
    end,
  },
  severity_sort = true,
})

-- Set signs symbol
local levels = { "Error", "Warn", "Info", "Hint" }
for _, l in pairs(levels) do
  local sign = "DiagnosticSign" .. l
  vim.fn.sign_define(sign, { text = "»", texthl = sign })
end
