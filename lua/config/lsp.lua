local lspconfig = require("lspconfig")

lspconfig.gopls.setup({
  on_init = function(client)
    -- Set `local` setting to the current Go module
    local path = client.workspace_folders[1].name
    local cmd = string.format("cd %s && go list -m", path)
    local mod = vim.trim(vim.fn.system(cmd))
    if vim.v.shell_error > 0 then
      vim.notify("Cannot determine module name: " .. mod, vim.log.levels.ERROR)
    else
      client.config.settings.gopls["local"] = mod
      client.notify("workspace/didChangeConfiguration")
    end
  end,
  settings = {
    gopls = {
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedvariable = true,
        unusedwrite = true,
        useany = true,
      },
      gofumpt = true,
      staticcheck = true,
    },
  },
})

lspconfig.pyright.setup({
  handlers = {
    -- Filter out `HINT` diagnostics: we only want severity of `INFO` or above
    ["textDocument/publishDiagnostics"] = function(err, result, ...)
      result.diagnostics = vim.tbl_filter(
        function(d) return d.severity ~= vim.diagnostic.severity.HINT end,
        result.diagnostics
      )
      vim.lsp.handlers["textDocument/publishDiagnostics"](err, result, ...)
    end,
  },
})

lspconfig.eslint.setup({})

lspconfig.tailwindcss.setup({
  root_dir = lspconfig.util.root_pattern("tailwind.config.js"),
})

require("rust-tools").setup({
  server = {
    on_attach = function(client)
      -- disable semantic tokens highlighting
      client.server_capabilities.semanticTokensProvider = nil
    end,
    settings = {
      ["rust-analyzer"] = {
        checkOnSave = {
          command = "clippy",
        },
      },
    },
  },
})
