vim.cmd.packadd("nvim-dap")
local dap = require("dap")
local widgets = require("dap.ui.widgets")

-- Define global mappings -----------------------------------------------------
local map = function(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { desc = "DAP: " .. desc })
end

map("<leader>db", dap.toggle_breakpoint, "toggle breakpoint")
map("<leader>dB", function()
  vim.ui.input(
    { prompt = "Breakpoint condition: " },
    function(cond) dap.toggle_breakpoint(cond, nil, nil, true) end
  )
end, "toggle condition breakpoint")
map("<leader>dp", function()
  vim.ui.input(
    { prompt = "Log point: " },
    function(log) dap.toggle_breakpoint(nil, nil, log, true) end
  )
end, "toggle log point")

map("<leader>dl", function() dap.list_breakpoints(true) end, "list breakpoints")
map("<leader>dc", dap.clear_breakpoints, "clear breakpoints")

map("<leader>dd", dap.continue, "start or continue debugging")
map("<leader>dL", dap.run_last, "run last configuration")

map("<leader>dr", function()
  dap.repl.toggle()

  -- If REPL window is open, move cursor to it in insert mode
  local repl_buf = vim.fn.getbufinfo("[dap-repl]")[1]
  if repl_buf then
    local win_id = repl_buf.windows[1]
    if win_id then
      vim.fn.win_gotoid(win_id)
      vim.cmd.startinsert({ bang = true })
    end
  end
end, "toggle REPL")

-- Define session mappings ----------------------------------------------------
-- Temporary mappings defined during debugging session.

-- Table with shape `{ mapping: { action, description } }`
local session_mappings = {
  ["<down>"] = { dap.step_over, "step over" },
  ["<left>"] = { dap.step_out, "step out" },
  ["<right>"] = { dap.step_into, "step in" },
  ["<leader>dh"] = { dap.run_to_cursor, "run to cursor" },

  ["<leader>de"] = {
    function() widgets.hover() end,
    "show value of expression under cursor",
  },
  ["<leader>df"] = {
    function() widgets.centered_float(widgets.frames) end,
    "display frames",
  },
  ["<leader>dT"] = {
    function() widgets.centered_float(widgets.threads) end,
    "display threads",
  },
  ["<leader>dv"] = {
    function() widgets.centered_float(widgets.scopes) end,
    "display variables in scope",
  },

  ["<leader>dk"] = { dap.disconnect, "disconnect" },
  ["<leader>dK"] = { dap.terminate, "terminate session" },
}

local add_session_mappings = function()
  for keys, mapping in pairs(session_mappings) do
    local action, desc = unpack(mapping)
    map(keys, action, desc)
  end
end

local remove_session_mappings = function()
  for keys, _ in pairs(session_mappings) do
    pcall(vim.keymap.del, "n", keys)
  end
end

dap.listeners.after.event_initialized["session_keymaps"] = add_session_mappings
dap.listeners.after.event_exited["session_keymaps"] = remove_session_mappings
dap.listeners.after.event_terminated["session_keymaps"] = remove_session_mappings

-- Define filetype mappings ---------------------------------------------------
local g = vim.api.nvim_create_augroup("dap", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dap-float",
  desc = "Define mappings for dap-float filetype",
  group = g,
  callback = function()
    vim.keymap.set(
      "n",
      "q",
      vim.cmd.close,
      { buffer = true, desc = "Close DAP floating window" }
    )
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "dap-repl",
  desc = "Define mappings for dap-repl filetype",
  group = g,
  callback = function()
    vim.keymap.set(
      { "i", "n" },
      "<c-c>",
      dap.repl.close,
      { buffer = true, desc = "Close DAP REPL window" }
    )
  end,
})

-- Define signs ---------------------------------------------------------------
vim.fn.sign_define({
  { name = "DapBreakpoint", texthl = "DiagnosticSignWarn" },
  { name = "DapBreakpointCondition", texthl = "DiagnosticSignWarn" },
  { name = "DapLogPoint", texthl = "DiagnosticSignWarn" },
  { name = "DapStopped", texthl = "DiagnosticSignWarn", linehl = "CursorLine" },
  {
    name = "DapBreakpointRejected",
    texthl = "DiagnosticSignError",
    linehl = "DiagnosticSignError",
  },
})
