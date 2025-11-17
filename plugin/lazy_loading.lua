-- Only load DAP debugging plugins when a Go file is opened
local dap_go_group = vim.api.nvim_create_augroup("dap_go_once", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Load DAP debugging plugins when filetype is 'go'",
  group = dap_go_group,
  pattern = "go",
  once = true,
  callback = function()
    local load_dap_go = function() require("rafik.plugins.dap") end

    xpcall(
      load_dap_go,
      function(err)
        vim.notify(
          "could not initialize DAP debugging plugins: " .. err,
          vim.log.levels.WARN
        )
      end
    )
  end,
})
