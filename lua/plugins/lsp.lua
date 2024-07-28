vim.cmd.packadd("nvim-lspconfig")
vim.cmd.packadd("rust-tools.nvim")

local configs = {
  -- https://github.com/mattn/efm-langserver
  efm = {
    cmd = {
      "efm-langserver",
      "-c",
      vim.fn.stdpath("config") .. "/efm-langserver-config.yaml",
    },
    init_options = { documentFormatting = true },
    filetypes = {
      "css",
      "fish",
      "graphql",
      "html",
      "htmldjango",
      "javascript",
      "javascriptreact",
      "json",
      "lua",
      "markdown",
      "python",
      "sh",
      "vim",
      "yaml",
    },
  },

  -- https://github.com/hrsh7th/vscode-langservers-extracted
  eslint = {},

  -- https://github.com/golang/tools/tree/master/gopls
  gopls = {
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
  },

  -- https://github.com/oxalica/nil
  nil_ls = {
    settings = {
      ["nil"] = {
        formatting = {
          command = { "alejandra" },
        },
      },
    },
  },

  -- https://github.com/microsoft/pyright
  pyright = {
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
  },

  -- https://github.com/astral-sh/ruff/tree/main/crates/ruff_server
  ruff = {
    on_init = function(client)
      -- Disable formatting capabilities.
      -- Let `black` handle it instead (via efm-langserver).
      client.server_capabilities.documentFormattingProvider = false

      -- Disable hover capabilities. Let `pyright` handle it instead.
      client.server_capabilities.hoverProvider = false
    end,
  },

  -- https://github.com/tailwindlabs/tailwindcss-intellisense
  tailwindcss = {
    root_dir = require("lspconfig").util.root_pattern("tailwind.config.js"),
  },

  -- https://github.com/tamasfe/taplo
  taplo = {},

  -- https://github.com/redhat-developer/yaml-language-server
  yamlls = {},
}

for server, config in pairs(configs) do
  require("lspconfig")[server].setup(config)
end

-- https://github.com/simrat39/rust-tools.nvim
local ok, rust_tools = pcall(require, "rust-tools")
if ok then
  rust_tools.setup({
    server = {
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
            command = "clippy",
          },
        },
      },
    },
  })
end
