-- Open the online documentation link for a topic if there is one listed in the
-- LSP hover window.
local rust_doc_from_lsp_hover = function()
  -- Open LSP hover window, or move cursor to it if already open
  vim.lsp.buf.hover()

  -- Move cursor to hover window, in case it wasn't opened already
  vim.lsp.buf.hover()

  -- Wait for 50ms to make sure that the async LSP request has time to complete
  vim.cmd.sleep("50m")

  -- The first line of the hover window from rust-analyzer often corresponds to
  -- the relevant topic for `rustup doc`.
  local topic = vim.fn.getline(1)
  require("lib/browse").rust_docs(topic)

  -- Close hover window
  vim.cmd.close()
end

vim.keymap.set("n", "<leader>D", rust_doc_from_lsp_hover, { buffer = true })
