vim.keymap.set("n", "<localleader>i", function()
  if vim.opt_local.winbar:get() ~= "" then
    vim.opt_local.winbar = ""
  else
    vim.opt_local.winbar = "%{%v:lua.require'jsonpath'.get()%}"
  end
end, { buf = 0, desc = "Toggle JSON path context" })
