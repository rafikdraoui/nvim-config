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

  local map = function(key, cmd, mode)
    mode = mode or "n"
    vim.api.nvim_buf_set_keymap(0, mode, key, cmd, { noremap = true })
  end
  map("K", "<cmd>lua vim.lsp.buf.hover()<cr>")
  map("<c-]>", "<cmd>lua vim.lsp.buf.definition()<cr>")
  map("<c-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>")
  map("<c-k>", "<cmd>lua vim.lsp.buf.signature_help()<cr>", "i")
  map("grd", "<cmd>lua vim.lsp.buf.document_symbol()<cr>")
  map("grr", "<cmd>lua vim.lsp.buf.rename()<cr>")
  map("grf", "<cmd>lua vim.lsp.buf.references()<cr>")
  map("gri", "<cmd>lua vim.lsp.buf.implementation()<cr>")
  map("grc", "<cmd>lua vim.lsp.buf.incoming_calls()<cr>")
  map("gro", "<cmd>lua vim.lsp.buf.outgoing_calls()<cr>")
  map("grt", "<cmd>lua vim.lsp.buf.type_definition()<cr>")
end

lspconfig.gopls.setup({
  on_attach = function(client)
    on_attach()

    -- Disable formatting: this is handled by null-ls
    client.resolved_capabilities.document_formatting = false
  end,
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
