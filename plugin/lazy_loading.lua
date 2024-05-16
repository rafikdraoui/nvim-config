-- Only load a plugin when a specific command is invoked
local lazy_command = function(command, plugin)
  vim.api.nvim_create_user_command(command, function(opts)
    vim.cmd.delcommand(command)
    vim.cmd.packadd(plugin)
    vim.cmd({ cmd = command, args = opts.fargs, bang = opts.bang })
  end, { nargs = "*", bang = true, range = true })
end
lazy_command("StartupTime", "vim-startuptime")
lazy_command("MundoToggle", "vim-mundo")
lazy_command("GV", "gv.vim")

-- Only load nvim-dap-go when a Go file is opened
local dap_go_group = vim.api.nvim_create_augroup("dap_go_once", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Load nvim-dap-go plugin when filetype is 'go'",
  group = dap_go_group,
  pattern = "go",
  once = true,
  callback = function()
    local load_dap_go = function()
      vim.cmd.packadd("nvim-dap-go")
      require("dap-go").setup()
    end

    xpcall(
      load_dap_go,
      function(err)
        vim.notify("could not initialize dap-go: " .. err, vim.log.levels.WARN)
      end
    )
  end,
})

-- Only load vimwiki when a vimwiki file is opened
local vw_group = vim.api.nvim_create_augroup("vimwiki_once", { clear = true })
vim.api.nvim_create_autocmd({ "FileType" }, {
  desc = "Load vimwiki plugin when filetype is 'vimwiki'",
  group = vw_group,
  pattern = "vimwiki",
  callback = function()
    -- Load vimwiki plugin
    vim.cmd.packadd("vimwiki")

    -- Self-delete autocommand to avoid infinite recursion below
    -- (using the `once` argument of `nvim_create_autocmd` isn't enough)
    vim.cmd.autocmd({ args = { "vimwiki_once" }, bang = true })

    -- Trigger FileType change to ensure that all of vimwiki is set up.
    vim.cmd.doautocmd("FileType vimwiki")
  end,
})
