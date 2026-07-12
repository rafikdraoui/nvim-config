-- Open the MDN documentation link for a CSS property if there is one listed in
-- the LSP hover window.
local mdn_doc_from_lsp_hover = function()
  -- Open LSP hover window, or move cursor to it if already open
  vim.lsp.buf.hover()

  -- Move cursor to hover window, in case it wasn't opened already
  vim.lsp.buf.hover()

  -- Wait for 50ms to make sure that the async LSP request has time to complete
  vim.cmd.sleep("50m")

  if vim.fn.search([[\[MDN Reference\](\zshttps://developer.mozilla.org/.*\ze)]]) then
    require("rafik.browse").url()
  end

  -- Close hover window
  vim.cmd.close()
end

vim.keymap.set(
  "n",
  "<leader>D",
  mdn_doc_from_lsp_hover,
  { buf = 0, desc = "Open MDN documentation link for CSS property" }
)
