local methods = vim.lsp.protocol.Methods

-- In addition to these custom mappings, the following default mappings are
-- defined:
--     gO: vim.lsp.buf.document_symbol
--    gra: vim.lsp.buf.code_action
--    gri: vim.lsp.buf.implementation
--    grn: vim.lsp.buf.rename
--    grr: vim.lsp.buf.references
--    grt: vim.lsp.buf.type_definition
--    grx: vim.lsp.codelens.run
local actions = {
  ["signature help"] = {
    method = methods.textDocument_signatureHelp,
    lhs = "<c-k>",
    rhs = vim.lsp.buf.signature_help,
    modes = { "n", "i" },
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
  ["code action (auto-apply)"] = {
    method = methods.textDocument_codeAction,
    lhs = "grA",
    rhs = function() vim.lsp.buf.code_action({ apply = true }) end,
  },
  ["format (async)"] = {
    method = methods.textDocument_formatting,
    lhs = "grf",
    rhs = function() vim.lsp.buf.format({ async = true }) end,
  },
  ["toggle code lenses"] = {
    method = methods.textDocument_codeLens,
    lhs = "<localleader>L",
    rhs = function() vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled()) end,
  },
  ["toggle semantic tokens highlights"] = {
    method = methods.textDocument_semanticTokens_full,
    lhs = "<localleader>T",
    rhs = function()
      vim.lsp.semantic_tokens.enable(not vim.lsp.semantic_tokens.is_enabled())
      print(
        string.format(
          "semantic tokens highlight: %s",
          vim.lsp.semantic_tokens.is_enabled()
        )
      )
    end,
  },
}

local set_mappings = function(client)
  for action, data in pairs(actions) do
    if client:supports_method(data.method) then
      local modes = data.modes or { "n" }
      vim.keymap.set(modes, data.lhs, data.rhs, { buf = 0, desc = "LSP: " .. action })
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
      if client:supports_method(methods.textDocument_formatting) then
        lsp_format.on_attach(client)
      end
    end
  end,
})
