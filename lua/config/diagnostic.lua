vim.diagnostic.config({
  float = {
    format = function(d)
      -- Include error code in diagnostic (if available)

      local code = d.code
      if not code and d.user_data and d.user_data.lsp then
        code = d.user_data.lsp.code
      end

      if code then
        return string.format("%s: %s [%s]", d.source, d.message, code)
      else
        return string.format("%s: %s", d.source, d.message)
      end
    end,
  },
  severity_sort = true,
})

-- Only display virtual text if g:enable_virtualtext is set
local default_virtual_text_handler = vim.diagnostic.handlers.virtual_text
vim.diagnostic.handlers.virtual_text = {
  show = function(...)
    if vim.g.enable_virtualtext == 1 then
      default_virtual_text_handler.show(...)
    end
  end,
  hide = default_virtual_text_handler.hide,
}

-- Set signs symbol
local levels = { "Error", "Warn", "Info", "Hint" }
for _, l in pairs(levels) do
  local sign = "DiagnosticSign" .. l
  vim.fn.sign_define(sign, { text = "»", texthl = sign })
end
