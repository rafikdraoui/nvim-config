-- TODO: Use `vim.lsp.protocol.Methods` from upstream once v0.10 is released.
local methods = {
  callHierarchy_incomingCalls = "callHierarchy/incomingCalls",
  callHierarchy_outgoingCalls = "callHierarchy/outgoingCalls",
  textDocument_codeAction = "textDocument/codeAction",
  textDocument_codeLens = "textDocument/codeLens",
  textDocument_documentSymbol = "textDocument/documentSymbol",
  textDocument_formatting = "textDocument/formatting",
  textDocument_hover = "textDocument/hover",
  textDocument_implementation = "textDocument/implementation",
  textDocument_references = "textDocument/references",
  textDocument_rename = "textDocument/rename",
  textDocument_signatureHelp = "textDocument/signatureHelp",
  textDocument_typeDefinition = "textDocument/typeDefinition",
}

local actions = {
  ["hover"] = {
    method = methods.textDocument_hover,
    lhs = "K",
    rhs = vim.lsp.buf.hover,
  },
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

    vim.opt_local.omnifunc = "v:lua.vim.lsp.omnifunc"
    set_mappings(client)

    -- enable formatting on save
    local ok, lsp_format = pcall(require, "lsp-format")
    if ok then
      lsp_format.on_attach(client)
    else
      vim.notify("lsp-format is not installed", vim.log.levels.WARN)
    end

    -- disable semantic tokens highlighting
    client.server_capabilities.semanticTokensProvider = nil
  end,
})
