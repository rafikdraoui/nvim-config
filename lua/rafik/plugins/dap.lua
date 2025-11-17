vim.cmd.packadd("nvim-dap")
vim.cmd.packadd("debugmaster.nvim")
vim.cmd.packadd("nvim-dap-go")

-- Configure debugmaster UI for DAP -------------------------------------------
local dm = require("debugmaster")

-- Define mappings
vim.keymap.set("n", "<leader>d", function()
  if vim.bo.filetype == "go" then
    dm.mode.toggle()
  end
end)
dm.keys.get("o").key = "<down>" -- step over
dm.keys.get("m").key = "<right>" -- step into
dm.keys.get("q").key = "<left>" -- step out
dm.keys.add({
  key = "dk",
  action = function() require("dap").disconnect({ terminateDebuggee = false }) end,
  desc = "Disconnect from session (without killing debugee)",
})
dm.keys.get("dt").key = "dz" -- remap to avoid conflict with `debug_test` below
dm.keys.add({
  key = "dt",
  action = function() require("dap-go").debug_test() end,
  desc = "Debug closest test (Go only)",
})
dm.keys.add({
  key = "dT",
  action = function() require("dap-go").debug_last_test() end,
  desc = "Debug last test (Go only)",
})

-- Define autocommand to track when debug mode is enabled
vim.g.debug_mode_enabled = false
vim.api.nvim_create_autocmd("User", {
  pattern = "DebugModeChanged",
  callback = function(args) vim.g.debug_mode_enabled = args.data.enabled end,
})

-- Define signs
vim.fn.sign_define({
  { name = "DapBreakpoint", texthl = "DiagnosticSignWarn" },
  { name = "DapBreakpointCondition", texthl = "DiagnosticSignWarn" },
  { name = "DapLogPoint", texthl = "DiagnosticSignWarn" },
  {
    name = "DapBreakpointRejected",
    texthl = "DiagnosticSignError",
    linehl = "DiagnosticSignError",
  },
  { name = "DapStopped", texthl = "DiagnosticSignWarn", linehl = "CursorLine" },
})

-- Configure Go debugging -----------------------------------------------------
require("dap-go").setup({})
if vim.g.dap_go_specs then
  local build_dap_config = function(spec)
    local args = spec.args or require("dap-go").get_arguments
    local program = "${workspaceFolder}/"
    if spec.package then
      program = program .. spec.package
    end
    return {
      type = "go",
      name = spec.name,
      request = "launch",
      program = program,
      args = args,
    }
  end

  local configs = vim.tbl_map(build_dap_config, vim.g.dap_go_specs)
  table.insert(configs, {
    type = "go",
    name = "Attach",
    mode = "local",
    request = "attach",
    processId = require("dap.utils").pick_process,
  })
  require("dap").configurations.go = configs
end
