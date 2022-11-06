local map = function(lhs, rhs, description)
  vim.keymap.set("n", lhs, rhs, { buffer = true, desc = description })
end

local set_mappings = function()
  local lsp = vim.lsp.buf
  map("K", lsp.hover, "LSP hover")
  map("<c-k>", lsp.signature_help, "LSP signature help")
  map("grd", lsp.document_symbol, "LSP document symbol")
  map("grr", lsp.rename, "LSP rename")
  map("grf", lsp.references, "LSP references")
  map("gri", lsp.implementation, "LSP implementation")
  map("grc", lsp.incoming_calls, "LSP incoming calls")
  map("gro", lsp.outgoing_calls, "LSP outgoing calls")
  map("grt", lsp.type_definition, "LSP type definition")
  map("gra", lsp.code_action, "LSP code action")
  map(
    "grA",
    function() lsp.code_action({ apply = true }) end,
    "LSP code action (auto-apply)"
  )
  map("grx", function() lsp.format({ async = true }) end, "LSP format (async)")

  vim.keymap.set(
    "i",
    "<c-l>", -- <c-k> is used for snippet trigger
    lsp.signature_help,
    { buffer = true, desc = "LSP signature" }
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
