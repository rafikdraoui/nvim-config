local lspconfig = require("lspconfig")

-- Fallback to using tags if `vim.lsp.buf.definition()` doesn't find anything
local default_definition_handler = vim.lsp.handlers["textDocument/definition"]
vim.lsp.handlers["textDocument/definition"] = function(err, result, ...)
  if result ~= nil then
    default_definition_handler(err, result, ...)
  else
    vim.cmd([[execute "silent! normal! \<c-]>"]])
  end
end

-- Buffer configuration
local on_attach = function()
  vim.api.nvim_buf_set_option(0, "omnifunc", "v:lua.vim.lsp.omnifunc")

  local function map(l, r, description, mode)
    mode = mode or "n"
    local opts = { buffer = true, desc = description }
    vim.keymap.set(mode, l, r, opts)
  end

  local lsp = vim.lsp.buf
  map("K", lsp.hover, "LSP hover")
  map("<c-]>", lsp.definition, "LSP definition")
  map("<c-k>", lsp.signature_help, "LSP signature help", { "n", "i" })
  map("grd", lsp.document_symbol, "LSP document symbol")
  map("grr", lsp.rename, "LSP rename")
  map("grf", lsp.references, "LSP references")
  map("gri", lsp.implementation, "LSP implementation")
  map("grc", lsp.incoming_calls, "LSP incoming calls")
  map("gro", lsp.outgoing_calls, "LSP outgoing calls")
  map("grt", lsp.type_definition, "LSP type definition")
end

lspconfig.gopls.setup({
  on_attach = on_attach,
  settings = {
    gopls = {
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
      },
      staticcheck = true,
    },
  },
})

lspconfig.pyright.setup({
  on_attach = on_attach,
})

lspconfig.eslint.setup({
  on_attach = on_attach,
})

lspconfig.tailwindcss.setup({
  autostart = false,
  on_attach = on_attach,
})
