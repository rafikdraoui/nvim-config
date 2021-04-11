local buffer_setup = function(client)
  local set_mapping = function(key, cmd, mode)
    mode = mode or 'n'
    vim.api.nvim_buf_set_keymap(0, mode, key, cmd, {noremap = true})
  end
  set_mapping('K', '<cmd>lua vim.lsp.buf.hover()<cr>')
  set_mapping('<c-]>', '<cmd>lua vim.lsp.buf.definition()<cr>')
  set_mapping('<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
  set_mapping('<c-k>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', 'i')
  set_mapping('gO', '<cmd>lua vim.lsp.buf.document_symbol()<cr>')
  set_mapping('grr', '<cmd>lua vim.lsp.buf.rename()<cr>')
  set_mapping('grf', '<cmd>lua vim.lsp.buf.references()<cr>')
  set_mapping('gri', '<cmd>lua vim.lsp.buf.implementation()<cr>')
  set_mapping('grc', '<cmd>lua vim.lsp.buf.incoming_calls()<cr>')
  set_mapping('grt', '<cmd>lua vim.lsp.buf.type_definition()<cr>')

  vim.api.nvim_buf_set_option(0, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
end

-- Disable diagnostics
local no_op = function() end
vim.lsp.handlers["textDocument/publishDiagnostics"] = no_op

-- Fallback to using tags if `vim.lsp.buf.definition()` doesn't find anything
local default_definition_handler = vim.lsp.handlers["textDocument/definition"]
local definition_with_fallback = function(_, method, result)
  if result ~= nil then
    default_definition_handler(nil, method, result)
  else
    vim.cmd([[execute "silent! normal! \<c-]>"]])
  end
end
vim.lsp.handlers["textDocument/definition"] = definition_with_fallback


require'lspconfig'.gopls.setup{
  on_attach = buffer_setup,
}

require'lspconfig'.pyright.setup{
  on_attach = buffer_setup,
}
