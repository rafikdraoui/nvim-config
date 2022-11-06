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

lspconfig.pyright.setup({})

lspconfig.eslint.setup({})

lspconfig.tailwindcss.setup({
  root_dir = lspconfig.util.root_pattern("tailwind.config.js"),
})
