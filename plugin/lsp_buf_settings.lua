local methods = vim.lsp.protocol.Methods

local actions = {
  ["signature help"] = {
    method = methods.textDocument_signatureHelp,
    lhs = "<c-k>",
    rhs = vim.lsp.buf.signature_help,
    modes = { "n", "i" },
  },
  ["document symbol"] = {
    method = methods.textDocument_documentSymbol,
    lhs = "grd",
    rhs = vim.lsp.buf.document_symbol,
  },
  ["rename"] = {
    method = methods.textDocument_rename,
    lhs = "grr",
    rhs = vim.lsp.buf.rename,
  },
  ["references"] = {
    method = methods.textDocument_references,
    lhs = "grf",
    rhs = vim.lsp.buf.references,
  },
  ["implementation"] = {
    method = methods.textDocument_implementation,
    lhs = "gri",
    rhs = vim.lsp.buf.implementation,
  },
  ["incoming calls"] = {
    method = methods.callHierarchy_incomingCalls,
    lhs = "grc",
    rhs = vim.lsp.buf.incoming_calls,
  },
  ["outgoing calls"] = {
    method = methods.callHierarchy_outgoingCalls,
    lhs = "gro",
    rhs = vim.lsp.buf.outgoing_calls,
  },
  ["type definition"] = {
    method = methods.textDocument_typeDefinition,
    lhs = "grt",
    rhs = vim.lsp.buf.type_definition,
  },
  ["code action"] = {
    method = methods.textDocument_codeAction,
    lhs = "gra",
    rhs = vim.lsp.buf.code_action,
  },
  ["code action (auto-apply)"] = {
    method = methods.textDocument_codeAction,
    lhs = "grA",
    rhs = function() vim.lsp.buf.code_action({ apply = true }) end,
  },
  ["format (async)"] = {
    method = methods.textDocument_formatting,
    lhs = "grx",
    rhs = function() vim.lsp.buf.format({ async = true }) end,
  },
  ["refresh code lenses"] = {
    method = methods.textDocument_codeLens,
    lhs = "grL",
    rhs = vim.lsp.codelens.refresh,
  },
  ["run code lens"] = {
    method = methods.textDocument_codeLens,
    lhs = "grl",
    rhs = vim.lsp.codelens.run,
  },
}

local set_mappings = function(client)
  for action, data in pairs(actions) do
    if client.supports_method(data.method) then
      local modes = data.modes or { "n" }
      vim.keymap.set(
        modes,
        data.lhs,
        data.rhs,
        { buffer = true, desc = "LSP: " .. action }
      )
    end
  end
end

local g = vim.api.nvim_create_augroup("lsp_buf_settings", { clear = true })
vim.api.nvim_create_autocmd({ "LspAttach" }, {
  group = g,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)

    set_mappings(client)

    -- enable formatting on save
    local ok, lsp_format = pcall(require, "lsp-format")
    if not ok then
      vim.notify("LspAttach: lsp-format is not installed", vim.log.levels.WARN)
    else
      if client.supports_method(methods.textDocument_formatting) then
        lsp_format.on_attach(client)
      end
    end

    -- disable semantic tokens highlighting
    client.server_capabilities.semanticTokensProvider = nil
  end,
})
