local buffer_setup = function(client)
  local set_mapping = function(key, cmd, modes)
    modes  = modes or {'n'}
    for _, mode in pairs(modes) do
      vim.api.nvim_buf_set_keymap(0, mode, key, cmd, {noremap = true})
    end
  end
  set_mapping('K', '<cmd>lua vim.lsp.buf.hover()<cr>')
  set_mapping('<c-]>', '<cmd>lua vim.lsp.buf.definition()<cr>')
  set_mapping('<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', {'n', 'i'})
  set_mapping('gO', '<cmd>lua vim.lsp.buf.document_symbol()<cr>')
  set_mapping('grr', '<cmd>lua vim.lsp.buf.rename()<cr>')
  set_mapping('grf', '<cmd>lua vim.lsp.buf.references()<cr>')
  set_mapping('gri', '<cmd>lua vim.lsp.buf.implementation()<cr>')
  set_mapping('grc', '<cmd>lua vim.lsp.buf.incoming_calls()<cr>')
  set_mapping('grt', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

  vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

-- Disable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = nil

require'lspconfig'.gopls.setup{
  on_attach = buffer_setup,
}
