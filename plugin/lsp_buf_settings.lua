local map = function(lhs, rhs, description)
  vim.keymap.set("n", lhs, rhs, { buffer = true, desc = "LSP: " .. description })
end

local set_mappings = function()
  local lsp = vim.lsp.buf
  map("K", lsp.hover, "hover")
  map("<c-k>", lsp.signature_help, "signature help")
  map("grd", lsp.document_symbol, "document symbol")
  map("grr", lsp.rename, "rename")
  map("grf", lsp.references, "references")
  map("gri", lsp.implementation, "implementation")
  map("grc", lsp.incoming_calls, "incoming calls")
  map("gro", lsp.outgoing_calls, "outgoing calls")
  map("grt", lsp.type_definition, "type definition")
  map("gra", lsp.code_action, "code action")
  map("grA", function() lsp.code_action({ apply = true }) end, "code action (auto-apply)")
  map("grx", function() lsp.format({ async = true }) end, "format (async)")
  map("grl", vim.lsp.codelens.run, "run code lens")
  map("grL", vim.lsp.codelens.refresh, "refresh code lenses")

  vim.keymap.set(
    "i",
    "<c-k>",
    lsp.signature_help,
    { buffer = true, desc = "LSP: signature" }
  )
end

local g = vim.api.nvim_create_augroup("lsp_buf_settings", { clear = true })
vim.api.nvim_create_autocmd({ "LspAttach" }, {
  group = g,
  callback = function()
    vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
    set_mappings()
  end,
})
