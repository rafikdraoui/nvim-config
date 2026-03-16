vim.cmd.packadd("nvim-lspconfig")

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
      "jinja",
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
          -- Disable "Incorrect or missing package comment"
          ST1000 = false,
        },
        gofumpt = true,
        staticcheck = true,
      },
    },
  },

  -- https://github.com/terror/just-lsp
  just = {},

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

  -- https://github.com/astral-sh/ruff/tree/main/crates/ruff_server
  ruff = {
    on_init = function(client)
      -- Disable formatting capabilities.
      -- Let `python-format` script handle it instead (via efm-langserver).
      client.server_capabilities.documentFormattingProvider = false
    end,
  },

  -- https://github.com/tailwindlabs/tailwindcss-intellisense
  tailwindcss = {},

  -- https://github.com/tamasfe/taplo
  taplo = {},

  -- https://github.com/astral-sh/ty
  ty = {},

  -- https://github.com/redhat-developer/yaml-language-server
  yamlls = {},
}

for server, config in pairs(configs) do
  vim.lsp.enable(server)
  vim.lsp.config(server, config)
end
